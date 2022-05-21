#####################################################################
# K8S HPA
#####################################################################
resource "kubernetes_horizontal_pod_autoscaler" "my_hpa" {
  metadata {
    name      = "omnistore-scheduled-services"
    namespace = var.namespace
  }

  spec {
    max_replicas = var.maxReplica
    min_replicas = var.minReplica
    target_cpu_utilization_percentage = var.utilizationCpu

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "omnistore-scheduled-services"
    }
  }
}