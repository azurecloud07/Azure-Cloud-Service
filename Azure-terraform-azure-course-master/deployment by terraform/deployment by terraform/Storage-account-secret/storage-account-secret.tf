#####################################################################
# K8S Storage Account Secret
#####################################################################
resource "kubernetes_secret" "storage-secret" {
  metadata {
    name = var.secretName
    namespace = var.namespace
  }

  data = {
    azurestorageaccountname = var.storageaccountName
    azurestorageaccountkey =  var.storageaccountKey
  }
  type = "Opaque"
}