variable "resourceGroupName" {
    type = string
    description = "name of resource group"
    default = "osmslwc"
}

variable "location" {
    type = string
    description = "location of your resource group"
    location = "eastus"
}

variable "securityGroupName" {
    type = string
    description = "name of security group"
    default = "osmslwc"
}

variable "vnetName" {
    type = string
    description = "name of virtual network"
    default = "osmslwc"
}

variable "environment" {
    description = "name of environment/client"
    default = "osmslwc"
}

variable "addressSpace" {
    description = "IP address range in virtual network"
    default = ["11.0.0.0/16"]
}

variable "subnetName" {
    type = string
    description = "name of subnet network"
    default = "osmslwc-sunbet"
}

variable "addressPrefix" {
    description = "IP address range in subnet"
    default = ["11.0.1.0/24"]
}

variable "postgresName" {
    type = string
    description = "name of postgres server"
    default = "osmslwc-db"
}

variable "postgresUser" {
    description = "Administrator user for postgres server"
    default = "postgres"
}

variable "postgresPassword" {
    description = "password for user Administrator"
    default = "root"
}

variable "postgresSKU" {
    description = "pricing tier of postgres server"
    default = "GP_Gen5_4"
}

variable "postgresVersion" {
    description = "version of postgres server"
    default = "10.0"
}

variable "postgresStorage" {
    description = "storage of postgres server"
    default = 5120
}

variable "acrName" {
    type = string
    description = "name of azure container registry"
    default = "osmslwc"
}

variable "acrSku"{
    description = "pricing tier of acr"
    default = "basic"
}

variable clusterName {
    description = "name of kubernates cluster"
    default = "osmslwc-k8s"
}

variable dnsPrefix {
    description = "dns name of kubernates cluster"
    default = "osmslwc-k8s"
}

variable "nodeCount" {
    description = "no of node for kubernates cluster"
    default = 1
}

variable "vmSize" {
    description = "pricing tier for kubernates cluster"
    default = "Standard_D2_v2"
}

variable "enableAutoScale" {
  description = "auto scale enable required or not"
  type        = bool
  default     = true
}

variable "minCount"{
    description = "no. of minimum node in kubernates cluster"
    default = 1
}

variable "maxCount"{
    description = "no. of maximum node in kubernates cluster"
    default = 2
}

variable "networkPlugin" {
    description = "netwwork usage for kubernates cluster"
    default = "azure"
}

variable "serviceCidr" {
    description = "service cidr value of kubernates cluster"
    default = "10.240.0.0/28"
}

variable "dnsServiceIp" {
    description = "dns service ip for kubernates cluster"
    default = "10.240.0.10"
}

variable "dockerBridgeCidr" {
    description = "docker bridge address for kubernates cluster"
    default = "172.17.0.1/16"
}

variable "loadBalancerSku" {
    description = "laodbalancer type in kubernates cluster"
    default = "Standard"
}

variable "redisName"{
    type = string
    description = "Name of redis server"
    default = osmslwc
}

variable "redisCapacity"{
    description = "pricing tier capacity for redis server"
    default = 2
}

variable "redisFamily" {
    description = "redis pricing tier family"
    default = "C"
}

variable "redisSku"{
    description = "redis pricing tier type"
    default = "Standard"
}

variable "enableRedisNonSSLPort"{
    description = "connection over non-ssl port in redis-server"
    type = bool
    default = true
}


