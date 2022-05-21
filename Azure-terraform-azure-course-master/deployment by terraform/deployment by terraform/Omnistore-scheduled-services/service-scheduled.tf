#####################################################################
# K8S Service
#####################################################################
resource "kubernetes_service" "omnistore-scheduled-services" {
  metadata {
    name = "omnistore-scheduled-services"
    namespace = var.namespace
  }
  spec {
    selector = {
      app = kubernetes_deployment.omnistore-scheduled-services.spec.0.template.0.metadata[0].labels.app
    }
    port {
      port = 8080
    }
    type = var.serviceType
  }
}


