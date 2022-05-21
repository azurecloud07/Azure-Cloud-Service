#####################################################################
# K8S Deployment
#####################################################################
resource "kubernetes_deployment" "omnistore-pos-services" {
  metadata {
    name = "omnistore-pos-services"
    namespace = var.namespace
    labels = {
      app = "omnistore-pos-services"
    }
  }
  spec {
    replicas = var.replica
    selector {
      match_labels = {
        app = "omnistore-pos-services"
      }
    }
    template {
      metadata {
        labels = {
          app = "omnistore-pos-services"
        }
      }
      spec {
        container {
          image = "gcr.io/omnistore-pos-services-kubernetes/omnistore-pos-services-example-paycheck:1.0"
          name = "omnistore-pos-services"
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
            name = "REDIS_HOST"
            value = var.redisHost
          }
          env {
            name = "REDIS_PASSWORD"
            value = var.redisPassword
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



