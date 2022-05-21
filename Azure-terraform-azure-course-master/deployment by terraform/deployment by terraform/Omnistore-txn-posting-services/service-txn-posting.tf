#####################################################################
# K8S Service
#####################################################################
resource "kubernetes_service" "omnistore-txn-posting-services" {
  metadata {
    name = "omnistore-txn-posting-services"
    namespace = var.namespace
  }
  spec {
    selector = {
      app = kubernetes_deployment.omnistore-txn-posting-services.spec.0.template.0.metadata[0].labels.app
    }
    port {
      port = 8080
    }
    type = var.serviceType
  }
}


