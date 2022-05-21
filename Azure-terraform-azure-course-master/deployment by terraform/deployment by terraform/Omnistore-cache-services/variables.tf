variable "namespace" {
    type = string
    description = "namespace name"
    default = "production"
}

variable "replica"{
    description = "no. of replica "
    default = 1
}

variable "dbHost" {
    type = string
    description = "db server instance url"
    default = "dbHost"
}

variable "dbName" {
    description = "name of the database"
    default = "osmsbaseproduct"
}

variable "dbUser" {
    description = "name of database user"
    default = "osmsbaseproduct"
}

variable "dbPassword"{
    description = "database password string"
    default = "Standard"
}

variable "archdbName" {
    description = "name of the archival database"
    default = "GRS"
}

variable "redisHost" {
    type = string
    description = "redis server url"
    default = "osmsbaseproduct"
}

variable "redisPassword" {
    description = "redis server key"
    default = "osmsbaseproduct"
}

variable "fileshareName" {
    description = "name of environment/client"
    default = "osmsbaseproduct"
}

variable "limitCpu" {
    type = string
    description = "limit of resource CPU"
    default = "500m"
}

variable "limitMemory" {
    description = "limit of resource MEMORY"
    default = "1000Mi"
}

variable "requestCpu" {
    type = string
    description = "requested of resource CPU"
    default = "250m"
}

variable "requestMemory" {
    description = "requested of resource MEMORY"
    default = "500Mi"
}

variable "storageaccountSecret" {
    type = string
    description = "secret of storage account"
    default = "osmsbaseproduct"
}

variable "fileshareName" {
    type = string
    description = "name of file share"
    default = osmsbaseproduct
}

variable "serviceType" {
    type = string
    description = "service type CluseterIP/LoadBalancer"
    default = "ClusterIP"
}

variable "minReplica" {
    description = "minimum replica for HPA"
    default = 1
}

variable "maxReplica" {
    description = "maximum replica for HPA"
    default = 5
}

variable "utilizationCpu" {
    description = "target cpu utilzation for HPA"
    default = 80
}

