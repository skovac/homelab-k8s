resource "kubernetes_service" "plex" {
  metadata {
    name = "plex"
  }
  spec {
    # Reached through the Traefik ingress (ingress.tf), no NodePort needed.
    type = "ClusterIP"
    selector = {
      app = kubernetes_deployment.plex.metadata.0.labels.app
    }
    port {
      name        = "webui-http"
      port        = 32400
      target_port = 32400
    }
  }
}

resource "kubernetes_service" "qbittorrent" {
  metadata {
    name = "qbittorrent"
  }
  spec {
    # Reached through the Traefik ingress (ingress.tf), no NodePort needed.
    type = "ClusterIP"
    selector = {
      app = kubernetes_deployment.qbittorrent.metadata.0.labels.app
    }
    port {
      port        = 80
      target_port = 30110
    }
  }
}


