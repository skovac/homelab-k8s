resource "kubernetes_pod" "plex" {
  metadata {
    name = "plex"
    labels = {
      app = "plex"
    }
  }

  spec {
    volume {
      name = "nfs-lib"
      nfs {
        server = local.nfs_server_ip
        path = "${var.nfs_mount_path}plex/media_library"
      }
    }

    volume {
      name = "nfs-config"
      nfs {
        server = local.nfs_server_ip
        path = "${var.nfs_mount_path}plex/config"
      }
    }

    container {
      image = "plexinc/pms-docker"
      name  = "plex"
      
      volume_mount {
        name = "nfs-lib"
        mount_path = "/data"
      }
      volume_mount {
        name = "nfs-config"
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