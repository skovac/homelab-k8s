resource "kubernetes_service" "plex" {
  metadata {
    name = "plex"
  }
  spec {
    type = "NodePort"
    selector = {
      app = kubernetes_deployment.plex.metadata.0.labels.app
    }
    port {
      name = "webui-http"
      port        = 32400
      target_port = 32400
      node_port = 32400      
    }
    port {
      name = "noidea1"
      port        = 3005
      target_port = 3005
      node_port = 30005
    }
    port {
      name = "noidea2"
      port        = 8324
      target_port = 8324
      node_port = 30832
    }
    port {
      name = "noidea3"
      port        = 32469
      target_port = 32469
      node_port = 32469
    }
    port {
      name = "noidea4"
      port        = 1900
      target_port = 1900
      node_port = 31900
    }
    port {
      name = "noidea5"
      port        = 32410
      target_port = 32410
      node_port = 32410
    }
    port {
      name = "noidea6"
      port        = 32412
      target_port = 32412
      node_port = 32412
    }
    port {
      name = "noidea7"
      port        = 32413
      target_port = 32413
      node_port = 32413
    }
    port {
      name = "noidea8"
      port        = 32414
      target_port = 32414
      node_port = 32414
    }
  }
}

resource "kubernetes_service" "qbittorrent" {
  metadata {
    name = "qbittorrent"
  }
  spec {
    type = "NodePort"
    selector = {
      app = kubernetes_deployment.qbittorrent.metadata.0.labels.app
    }
    port {
      port        = 80
      target_port = 30110
      node_port = 30110
    }
  }
}


/*
resource "kubernetes_service" "nextcloud" {
  metadata {
    name = "nextcloud"
  }
  spec {
    type = "NodePort"
    selector = {
      app = kubernetes_pod.nextcloud.metadata.0.labels.app
    }
    port {
      port        = 8080
      target_port = 80
      node_port = 30100
    }
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
*/
