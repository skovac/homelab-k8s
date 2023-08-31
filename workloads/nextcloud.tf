resource "kubernetes_config_map" "postgres-nc-config" {
  metadata {
    name = "postgres-nc-config"
    labels = {
      app = "postgres-nc"
    }
  }
  data = {
    POSTGRES_DB = "nextcloud"
    POSTGRES_USER = "nextcloud"
    POSTGRES_PASSWORD = "${var.postgres_nc_pw}"
  }
}

resource "kubernetes_pod" "postgres-nc" {
  metadata {
    name = "postgres-nc"
    labels = {
      app = "postgres-nc"
    }
  }
  
  spec {
    volume {
      name = "data"
      nfs {
        server = local.nfs_server_ip
        path = "${var.nfs_mount_path}postgres/nextcloud/data"
      }
    }
    container {
      name = "postgres-nc"
      image = "postgres:15"
      port {
        container_port = 5432
      }
      env_from {
        config_map_ref {
          name = "postgres-nc-config"
        }
      }
      volume_mount {
        name = "data"
        mount_path = "var/lib/postgresql/data"
      }
    }
  }
}

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
      image = "nextcloud:27-apache"
      name = "nextcloud"

      env {
        name = "POSTGRES_HOST"
        value = "postgres-nc"
      }
      env {
        name = "POSTGRES_DB"
        value = "nextcloud"
      }
      env {
        name = "POSTGRES_USER"
        value = "nextcloud"
      }
      env {
        name = "POSTGRES_PASSWORD"
        value = "${var.postgres_nc_pw}"
      }
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