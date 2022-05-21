#####################################################################
# K8S Service
#####################################################################
resource "kubernetes_service" "omnistore-pos-services" {
  metadata {
    name = "omnistore-pos-services"
    namespace = var.namespace
  }
  spec {
    selector = {
      app = kubernetes_deployment.omnistore-pos-services.spec.0.template.0.metadata[0].labels.app
    }
    port {
      port = 8080
    }
    type = var.serviceType
  }
}


