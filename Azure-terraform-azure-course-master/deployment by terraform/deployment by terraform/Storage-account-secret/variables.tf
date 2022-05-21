variable "namespace" {
    type = string
    description = "namespace name"
    default = "production"
}

variable "secretName"{
    description = "name of secret "
    default = "omnistore"
}

variable "storageaccountName" {
    type = string
    description = "name of storage account"
    default = "dbHost"
}

variable "storageaccountKey" {
    description = "access key of storage account"
    default = "osmsbaseproduct"
}

