#####################################################################
# K8S Deployment
#####################################################################
resource "kubernetes_deployment" "omnistore-txn-posting-services" {
  metadata {
    name = "omnistore-txn-posting-services"
    namespace = var.namespace
    labels = {
      app = "omnistore-txn-posting-services"
    }
  }
  spec {
    replicas = var.replica
    selector {
      match_labels = {
        app = "omnistore-txn-posting-services"
      }
    }
    template {
      metadata {
        labels = {
          app = "omnistore-txn-posting-services"
        }
      }
      spec {
        container {
          image = "gcr.io/omnistore-txn-posting-services-kubernetes/omnistore-txn-posting-services-example-paycheck:1.0"
          name = "omnistore-txn-posting-services"
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



