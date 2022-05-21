#####################################################################
# K8S Deployment
#####################################################################
resource "kubernetes_deployment" "omnistore-scheduled-services" {
  metadata {
    name = "omnistore-scheduled-services"
    namespace = var.namespace
    labels = {
      app = "omnistore-scheduled-services"
    }
  }
  spec {
    replicas = var.replica
    selector {
      match_labels = {
        app = "omnistore-scheduled-services"
      }
    }
    template {
      metadata {
        labels = {
          app = "omnistore-scheduled-services"
        }
      }
      spec {
        container {
          image = "gcr.io/omnistore-scheduled-services-kubernetes/omnistore-scheduled-services-example-paycheck:1.0"
          name = "omnistore-scheduled-services"
          imagePullPolicy = "Always"
         
          volumeMounts {
            name = "azurefileshare"
            value = "/opt/omnistore-home"
          }
          env {
            name = "DB_HOST"
            value = var.dbHost
          }
          env {
            name = "DB_NAME"
            value = var.dbName
          }
          env {
            name = "DB_USER"
            value = var.dbUser
          }
          env {
            name = "DB_PASSWORD"
            value = var.dbPassword
          }
          env {
            name = "ARCH_DB_NAME"
            value = var.archdbName
          }
          resources {
            limits {
              cpu = var.limitCpu
              memory = var.limitMemory
            }
            requests {
              cpu = var.requestCpu
              memory = var.requestsMemory
            }
          }
          port {
            container_port = 8080
          }
        volumes {
          name = "azurefileshare"
          azureFile {
            secretName = var.storageaccountSecret
            shareName = "${var.fileshareName}/omnistore-home"
            readOnly = "false"
           }
          }
        nodeSelector {
          app = "java-apps"
         }
        }
      }
    }
  }
}



