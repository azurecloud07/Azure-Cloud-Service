#####################################################################
# K8S Namespace
#####################################################################
resource "kubernetes_namespace" "namespace" {
  metadata {
    annotations = {
      name = "namespace-annotation"
    }

    labels = {
      mylabel = "label-value"
    }
    
    name = var.namespaceName
  }
}