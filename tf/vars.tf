variable "ip_prefix" {
  type = string
  default = "192.168.178"
}

variable "nfs_mount_path" {
  type = string
  default = "/srv/nfs/"
}


variable "postgres_nc_pw" {
  type = string
}

variable "qbit_pw" {
  type = string
}

variable "proton_user" {
  type = string
}

variable "proton_pw" {
  type = string
}

variable "domain" {
  type    = string
  default = "kovacs.tech"
}

variable "acme_email" {
  type        = string
  description = "Contact address for the Let's Encrypt account (expiry and problem notices)."
}

variable "cluster_issuer" {
  type        = string
  default     = "letsencrypt-prod"
  description = "cert-manager ClusterIssuer used by the ingresses: letsencrypt-prod or letsencrypt-staging."

  validation {
    condition     = contains(["letsencrypt-prod", "letsencrypt-staging"], var.cluster_issuer)
    error_message = "cluster_issuer must be letsencrypt-prod or letsencrypt-staging."
  }
}


locals {
  nfs_server_ip = "${var.ip_prefix}.26"
  nginx_lb_ip = "${var.ip_prefix}.200"
  nextcloud_lb_ip = "${var.ip_prefix}.220"
  plex_lb_ip = "${var.ip_prefix}.221"
  qbittorrent_lb_ip = "${var.ip_prefix}.222"
}