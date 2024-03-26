
resource "kubernetes_deployment" "plex" {
  metadata {
    name = "plex"
    labels = {
      app = "plex"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "plex"
      }
    }

    template {
      metadata {
        labels = {
          app = "plex"
        }
      }
      spec {
        volume {
          name = "library"
          host_path {
            path = "/mnt/rsync.net/media/"
          }
        }

        volume {
          name = "config"
          host_path {
            path = "/home/seb/k8s/plex/config"
          }
        }
        container {
          image = "plexinc/pms-docker"
          name  = "plex"

          volume_mount {
            name = "library"
            mount_path = "/data"
          }
          volume_mount {
            name = "config"
            mount_path = "/config"
          }

          port {
            container_port = 32400
          }
          port {
            container_port = 3005
          }
          port {
            container_port = 8324
          }
          port {
            container_port = 32469
          }
          port {
            container_port = 1900
          }
          port {
            container_port = 32410
          }
          port {
            container_port = 32412
          }
          port {
            container_port = 32413
          }
          port {
            container_port = 32414
          }
        }
      }
    }
  }
}