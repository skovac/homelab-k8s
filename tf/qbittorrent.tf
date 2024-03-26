resource "kubernetes_deployment" "qbittorrent" {
  metadata {
    name = "qbittorrent"
    labels = {
      app = "qbittorrent"
    } 
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "qbittorrent"
      }
    }

    template {
      metadata {
        labels = {
          app = "qbittorrent"
        }
      }
      spec {
        volume {
          name = "config"
          host_path {
            path = "/home/seb/k8s/qbit/config"
          }
        }
        volume {
          name = "media"
          host_path {
            path = "/mnt/rsync.net/media/"
          }
        }
        
        container {
          image = "ghcr.io/qdm12/gluetun"
          name = "gluetun"
          image_pull_policy = "Always"
          security_context {
            capabilities {
              add = ["NET_ADMIN"]
            }
          }
          env {
            name = "VPN_SERVICE_PROVIDER"
            value = "protonvpn"
          }
          env {
            name = "OPENVPN_USER"
            value = "${var.proton_user}"
          }
          env {
            name = "OPENVPN_PASSWORD"
            value = "${var.proton_pw}"
          }
          env {
            name = "SERVER_COUNTRIES"
            value = "Germany"
          }
          env {
            name = "FIREWALL_INPUT_PORTS"
            value = 30110
          }
        }

        container {
          image = "linuxserver/qbittorrent"
          name = "qbittorrent"

          env {
            name = "WEBUI_PORT"
            value = 30110
          }
          env {
            name = "WEBUI_PASSWORD_PBKDF2"
            value = "${var.qbit_pw}"
          }
          volume_mount {
            name = "config"
            mount_path = "/config/"
          }
          volume_mount {
            name = "media"
            mount_path = "/mnt/rsync.net/media/"
          }
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}