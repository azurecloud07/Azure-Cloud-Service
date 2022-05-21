#####################################################################
# K8S Deployment
#####################################################################
resource "kubernetes_deployment" "MyDeployment" {
  metadata {
    name = "MyDeployment"
    labels = {
      app = "MyDeployment"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "MyDeployment"
      }
    }
    template {
      metadata {
        labels = {
          app = "MyDeployment"
        }
      }
      spec {
        container {
          image = "gcr.io/MyDeployment-kubernetes/MyDeployment-example-paycheck:1.0"
          name = "MyDeployment"
          port {
            container_port = 8000
          }
          port {
            container_port = 8080
          }
          env {
            name = "CLOUD_SQL_INSTANCE"
            value = var.cloudsql_instance
          }
          env {
            name = "DB_NAME"
            value = var.cloudsql_db_name
          }
          env {
            name = "DB_USER"
            value = var.cloudsql_db_user
          }
          env {
            name = "DB_PASS"
            value = var.cloudsql_db_password
          }
          resources {
            limits {
              cpu = "0.5"
              memory = "1024Mi"
            }
            requests {
              cpu = "250m"
              memory = "512Mi"
            }
          }
        }
      }
    }
  }
}


#####################################################################
# K8S Service
#####################################################################
resource "kubernetes_service" "MyDeployment" {
  metadata {
    name = "MyDeployment"
  }
  spec {
    selector = {
      app = kubernetes_deployment.MyDeployment.spec.0.template.0.metadata[0].labels.app
    }
    port {
      name = "dashboard"
      port = 8000
      target_port = 8000
    }
    port {
      name = "rest-api"
      port = 8080
      target_port = 8080
    }
    type = "LoadBalancer"
  }
}
#####################################################################
# K8S HPA
#####################################################################
resource "kubernetes_deployment" "my_deployment" {
  metadata {
    name      = "MyDeployment"
  }

  lifecycle {
    ignore_changes = [
      # Number of replicas is controlled by
      # kubernetes_horizontal_pod_autoscaler, ignore the setting in this
      # deployment template.
      spec[0].replicas,
    ]
  }

  spec {
    replicas = 1  // default value
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "my_hpa" {
  metadata {
    name      = "MyHPA"
  }

  spec {
    max_replicas = 16
    min_replicas = 5

    target_cpu_utilization_percentage = 80

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "MyDeployment"
    }
  }
}
