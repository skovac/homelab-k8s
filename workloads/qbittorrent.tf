resource "kubernetes_pod" "qbittorrent" {
  metadata {
    name = "qbittorrent"
    labels = {
      app = "qbittorrent"
    } 
  }

  spec {
    container {
      image = "linuxserver/qbittorrent"
      name = "qbittorrent"

      env {
        name = "WEBUI_PORT"
        value = 8080
      }
      port {
        container_port = 8080
      }
    }
  }
}