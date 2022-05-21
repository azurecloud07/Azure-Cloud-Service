#####################################################################
# K8S Service
#####################################################################
resource "kubernetes_service" "omnistore-cache-services" {
  metadata {
    name = "omnistore-cache-services"
    namespace = var.namespace
  }
  spec {
    selector = {
      app = kubernetes_deployment.omnistore-cache-services.spec.0.template.0.metadata[0].labels.app
    }
    port {
      port = 8080
    }
    type = var.serviceType
  }
}


