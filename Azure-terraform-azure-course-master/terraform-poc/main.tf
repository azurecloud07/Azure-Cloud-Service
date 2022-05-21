# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }

  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
}

#create resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resourceGroupName
  location = var.location
  tags = {
    Project   = "Omnistore"
    Environment = var.environment
    SWON       = "1046592"
    Component = "ResourceGroup"
  }
}

#create security group
resource "azurerm_network_security_group" "nsg" {
  name                = var.securityGroupName
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = {
    Project   = "Omnistore"
    Environment = var.environment
    SWON       = "1046592"
    Component = "SecurityGroup"
  }
}

#create security rule
resource "azurerm_network_security_rule" "Port80" {
  name                        = "Allow80"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = var.vnetName
    address_space       = var.addressSpace
    location            = var.location
    resource_group_name = azurerm_resource_group.rg.name
    tags = {
    Project   = "Omnistore"
    Environment = var.environment
    SWON       = "1046592"
    Component = "VirtualNetwork"
  }

}

#Create a subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.subnetName
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes       = var.addressPrefix
  resource_group_name = azurerm_resource_group.rg.name
}

#subnet security group association
resource "azurerm_subnet_network_security_group_association" "sga" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

#create postgresql-server
resource "azurerm_postgresql_server" "psql" {
  name                = var.postgresName
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  administrator_login          = var.postgresUser
  administrator_login_password = var.postgresPassword

  sku_name   = var.postgresSku
  version    = var.postgresVersion
  storage_mb = var.postgresStorage

  backup_retention_days        = 7
  geo_redundant_backup_enabled = true
  auto_grow_enabled            = true

  public_network_access_enabled    = true
  ssl_enforcement_enabled          = false
  tags = {
    Project   = "Omnistore"
    Environment = var.environment
    SWON       = "1046592"
    Component = "PostgresServer"
  }
}

#create acr for kubernates
resource "azurerm_container_registry" "acr" {
  name                = var.acrName
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.acrSku
  admin_enabled       = false
  tags = {
    Project   = "Omnistore"
    Environment = var.environment
    SWON       = "1046592"
    Component = "ConatinerRegistry"
  }
}

#create kubernates cluster
resource "azurerm_kubernetes_cluster" "k8s" {
    name                = var.clusterName
    location            = var.location
    resource_group_name = azurerm_resource_group.rg.name
    dns_prefix          = var.dnsPrefix
  
    default_node_pool {
        name            = "agentpool"
        node_count      = var.nodeCount
        vm_size         = var.vmSize
        type                = "VirtualMachineScaleSets"
        availability_zones  = ["1", "2", "3"]
        enable_auto_scaling = var.enableAutoScale
        min_count           = var.minCount
        max_count           = var.maxCount
        vnet_subnet_id  = azurerm_subnet.subnet.id
        
    }
    identity {
      type = "SystemAssigned"
   }

 addon_profile {
    http_application_routing {
      enabled = true
    }
  }

    network_profile {
        network_plugin = var.networkPlugin
        service_cidr = var.serviceCidr 
        dns_service_ip = var.dnsServiceIp
        docker_bridge_cidr = var.dockerBridgeCidr
        load_balancer_sku = var.loadBalancerSku
        network_policy     = "azure"
    }
    tags = {
    Project   = "Omnistore"
    Environment = var.environment
    SWON       = "1046592"
    Component = "Kubernates"
  }
}

#create redis-cache
resource "azurerm_redis_cache" "redis" {
  name                = var.redisName
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  capacity            = var.redisCapacity
  family              = var.redisFamily
  sku_name            = var.redisSku
  enable_non_ssl_port = var.enableRedisNonSSLPort
  minimum_tls_version = "1.2"

  redis_configuration {
  }
  tags = {
    Project   = "Omnistore"
    Environment = var.environment
    SWON       = "1046592"
    Component = "RedisServer"
  }
}