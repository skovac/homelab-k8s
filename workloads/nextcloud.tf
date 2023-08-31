resource "kubernetes_pod" "nextcloud" {
  metadata {
    name = "nextcloud"
    labels = {
      app = "nextcloud"
    }
  }

  spec {
    volume {
      name = "www"
      nfs {
        server = local.nfs_server_ip
        path = "${var.nfs_mount_path}nextcloud/var/www/html"
      }
    }

    container {
      image = "nextcloud"
      name = "nextcloud"

      volume_mount {
        name = "www"
        mount_path = "/var/www/html"
      }

      port {
        container_port = 80
      }
    }
  }
}