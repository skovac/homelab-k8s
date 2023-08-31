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


locals {
  nfs_server_ip = "${var.ip_prefix}.26"

  nginx_lb_ip = "${var.ip_prefix}.200"
  nextcloud_lb_ip = "${var.ip_prefix}.220"
  plex_lb_ip = "${var.ip_prefix}.221"
}