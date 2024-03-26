resource "kubernetes_manifest" "ip-address-pool" {
  manifest = {
    "apiVersion" = "metallb.io/v1beta1"
    "kind" = "IPAddressPool"
    "metadata" = {
      "name" = "ip-address-pool"
      "namespace" = "metallb-system"
    }
    "spec" = {
      "addresses" = [
        "192.168.178.200-192.168.178.250",
      ]
    }
  }
}


resource "kubernetes_manifest" "l2-advertisement" {
  manifest = {
    "apiVersion" = "metallb.io/v1beta1"
    "kind" = "L2Advertisement"
    "metadata" = {
      "name" = "example"
      "namespace" = "metallb-system"
    }
  }
}
