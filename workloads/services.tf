resource "kubernetes_service" "nginx" {
  metadata {
    name = "nginx"
    annotations = {
        "metallb.universe.tf/address-pool" = "ip-address-pool"        
    }
  }
  spec {
    selector = {
      app = kubernetes_pod.nginx.metadata.0.labels.app
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
    load_balancer_ip = local.nginx_lb_ip
  }
}

resource "kubernetes_service" "plex" {
  metadata {
    name = "plex"
    annotations = {
        "metallb.universe.tf/address-pool" = "ip-address-pool"        
    }
  }
  spec {
    selector = {
      app = kubernetes_pod.plex.metadata.0.labels.app
    }
    port {
      name = "webui-http"
      port        = 80
      target_port = 32400
    }
    port {
      name = "webui-std-port"
      port        = 32400
      target_port = 32400
    }
    port {
      name = "noidea1"
      port        = 3005
      target_port = 3005
    }
    port {
      name = "noidea2"
      port        = 8324
      target_port = 8324
    }
    port {
      name = "noidea3"
      port        = 32469
      target_port = 32469
    }
    port {
      name = "noidea4"
      port        = 1900
      target_port = 1900
    }
    port {
      name = "noidea5"
      port        = 32410
      target_port = 32410
    }
    port {
      name = "noidea6"
      port        = 32412
      target_port = 32412
    }
    port {
      name = "noidea7"
      port        = 32413
      target_port = 32413
    }
    port {
      name = "noidea8"
      port        = 32414
      target_port = 32414
    }

    type = "LoadBalancer"
    load_balancer_ip = local.plex_lb_ip
  }
}

resource "kubernetes_service" "nextcloud" {
  metadata {
    name = "nextcloud"
    annotations = {
        "metallb.universe.tf/address-pool" = "ip-address-pool"        
    }
  }
  spec {
    selector = {
      app = kubernetes_pod.nextcloud.metadata.0.labels.app
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
    load_balancer_ip = local.nextcloud_lb_ip
  }
}

resource "kubernetes_service" "postrges-nc" {
  metadata {
    name = "postgres-nc"
  }
  spec {
    selector = {
      app = kubernetes_pod.postgres-nc.metadata.0.labels.app
    }
    port {
      port = 5432
      target_port = 5432
    }
  }
}

resource "kubernetes_service" "qbittorrent" {
  metadata {
    name = "qbittorrent"
    annotations = {
        "metallb.universe.tf/address-pool" = "ip-address-pool"        
    }
  }
  spec {
    selector = {
      app = kubernetes_pod.qbittorrent.metadata.0.labels.app
    }
    port {
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"
    load_balancer_ip = local.qbittorrent_lb_ip
  }
}
