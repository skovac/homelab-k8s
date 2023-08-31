terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

resource "kubernetes_pod" "nginx" {
  metadata {
    name = "nginx"
    labels = {
      app = "nginx"
    }
  }
  spec {
    container {
      name = "nginx"
      image = "nginx:latest"
      port {
        container_port = 80
        name = "http-web-svc"
      }
    }
  }
}

