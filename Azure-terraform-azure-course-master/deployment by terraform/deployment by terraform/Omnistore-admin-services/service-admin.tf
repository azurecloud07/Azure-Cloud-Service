#####################################################################
# K8S Service
#####################################################################
resource "kubernetes_service" "omnistore-admin-services" {
  metadata {
    name = "omnistore-admin-services"
    namespace = var.namespace
  }
  spec {
    selector = {
      app = kubernetes_deployment.omnistore-admin-services.spec.0.template.0.metadata[0].labels.app
    }
    port {
      port = 8080
    }
    type = var.serviceType
  }
}


