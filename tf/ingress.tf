# In-cluster ingress: Traefik (host network, ports 80/443) + cert-manager
# (Let's Encrypt, HTTP-01, one certificate per hostname).
#
# Versions are pinned to the newest releases that still support the cluster's
# Kubernetes 1.29. Bump them after upgrading the cluster:
#   - Traefik chart 42.x+ requires Kubernetes >= 1.30
#   - cert-manager 1.18 is end-of-life; 1.20+ requires Kubernetes >= 1.32

resource "helm_release" "traefik" {
  name             = "traefik"
  repository       = "https://traefik.github.io/charts"
  chart            = "traefik"
  version          = "41.7.1" # Traefik v3.7.14
  namespace        = "traefik"
  create_namespace = true

  values = [file("${path.module}/values/traefik.yaml")]
}

resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.18.6"
  namespace        = "cert-manager"
  create_namespace = true

  values = [yamlencode({
    crds = { enabled = true }
  })]
}

resource "helm_release" "cluster_issuers" {
  name      = "cluster-issuers"
  chart     = "${path.module}/charts/cluster-issuers"
  namespace = "cert-manager"

  values = [yamlencode({
    email            = var.acme_email
    ingressClassName = "traefik"
  })]

  depends_on = [helm_release.cert_manager]
}

# Nextcloud AIO runs in Docker on the host with Apache on 127.0.0.1:11000.
# Traefik uses the host network, so 127.0.0.1 is the host's loopback.
resource "kubernetes_service_v1" "nextcloud" {
  metadata {
    name = "nextcloud-aio"
  }
  spec {
    type          = "ExternalName"
    external_name = "127.0.0.1"
    port {
      port = 11000
    }
  }
}

locals {
  web_apps = {
    plex = {
      host    = "plex.${var.domain}"
      service = kubernetes_service.plex.metadata[0].name
      port    = 32400
    }
    qbittorrent = {
      host    = "qbit.${var.domain}"
      service = kubernetes_service.qbittorrent.metadata[0].name
      port    = 80
    }
    nextcloud = {
      host    = "nc.${var.domain}"
      service = kubernetes_service_v1.nextcloud.metadata[0].name
      port    = 11000
    }
  }
}

resource "kubernetes_ingress_v1" "web" {
  for_each = local.web_apps

  metadata {
    name = each.key
    annotations = {
      "cert-manager.io/cluster-issuer"                   = var.cluster_issuer
      "traefik.ingress.kubernetes.io/router.entrypoints" = "websecure"
      "traefik.ingress.kubernetes.io/router.tls"         = "true"
    }
  }

  spec {
    ingress_class_name = "traefik"

    tls {
      hosts       = [each.value.host]
      secret_name = "${each.key}-tls"
    }

    rule {
      host = each.value.host
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = each.value.service
              port {
                number = each.value.port
              }
            }
          }
        }
      }
    }
  }

  depends_on = [helm_release.traefik, helm_release.cluster_issuers]
}
