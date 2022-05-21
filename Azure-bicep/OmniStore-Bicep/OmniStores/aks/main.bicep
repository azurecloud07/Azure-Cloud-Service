@description('Specifies the address prefixes of the virtual network.')
param virtualNetworkAddressPrefixes string = '10.0.0.0/8'

@description('Specifies the name of the subnet hosting the system node pool of the AKS cluster.')
param aksSubnetName string = 'AksSubnet'

@description('Specifies the address prefix of the subnet hosting the system node pool of the AKS cluster.')
param aksSubnetAddressPrefix string = '10.1.0.0/16'

@description('Specifies the name of the subnet used for SQL.')
param dbSubnetName string = 'dbSubnet'

@description('Specifies the address prefix of the subnet used for SQL.')
param dbSubnetAddressPrefix string = '10.4.0.0/16'

@description('Specifies the globally unique name for the storage account.')
param blobStorageAccountName string = 'os${envName}sa'

@description('Microservice Name used across the diff environment')
param microServiceName string = 'omnistores'

@description('EnvName will be fetch from pipeline or different env variable')
param envName string = 'dev'

@description('Specifies the name for the SQL server & SQL database')
param dbServerName string = '${microServiceName}${envName}'
param dbAdministratorLogin string = '${envName}postgres'

@secure()
param dbAdministratorLoginPassword string = 'root'
param dbServerVersion string = '13'

@allowed([
  'Free'
  'Standalone'
  'PerNode'
  'PerGB2018'
])
@description('Specifies the service tier of the workspace: Free, Standalone, PerNode, Per-GB.')
param logAnalyticsSku string = 'PerGB2018'

@description('Specifies the workspace data retention in days. -1 means Unlimited retention for the Unlimited Sku. 730 days is the maximum allowed for all other Skus.')
param logAnalyticsRetentionInDays int = 30

@description('Specific the name of the redisCache')
param redisCacheName string = '${microServiceName}${envName}-redisCache'

@allowed([
  'C'
  'P'
])
param redisfamily string = 'C'

@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param redisCacheType string = 'Basic'

@description('Specific the name of the redisCache')
param managedClusters__name string = '${envName}-k8s'

param publicIp_Address_name string = '${microServiceName}${envName}-public-ip'
param publicIp_Address_sku_tier string = 'Regional'
param publicIp_Address_sku_name string = 'Standard'



@description('private dns zone name')
param dbprivatednsname string = envName
@description('enable auto registration for private dns')
param dbprivatednsautoRegistration bool = false


@description('Name of the virtual machine.')
param vmName string = '${envName}-vm'
@description('Size of the virtual machine.')
param vmSize string = 'Standard_B16ms'
param OSVersion string = '2019-Datacenter'

@description('Username for the Virtual Machine.')
param adminUsername string = 'Admin123'

@description('Password for the Virtual Machine.')
@secure()
param adminPassword string = 'Admin@123'

param nicName string = 'nic-vm-${envName}'
param publicnicIpName string = 'nic-ip-${envName}'



module vnet 'modules/vnet.bicep' = {
  name: 'vnet'
  params: {
    virtualNetworkAddressPrefixes: virtualNetworkAddressPrefixes
    aksSubnetName: aksSubnetName
    aksSubnetAddressPrefix: aksSubnetAddressPrefix
    dbSubnetName: dbSubnetName
    dbSubnetAddressPrefix: dbSubnetAddressPrefix
  }
  dependsOn:[]
}

module blobStorage 'modules/storageaccount.bicep' = {
  name: 'blobStorage'
  params: {
    StorageAccountName: blobStorageAccountName
  }
}




module workspace 'modules/log-analytics.bicep' = {
  name: 'workspace'
  params: {
    logAnalyticsSku: logAnalyticsSku
    logAnalyticsRetentionInDays: logAnalyticsRetentionInDays
  }
}

module redisCache 'modules/red-cache.bicep' = {
  name : redisCacheName
  params: {
    redisCacheName : redisCacheName
    redisCacheType: redisCacheType
    redisfamily: redisfamily
  }  
}

module publicIp_Address 'modules/publicip.bicep' = {
  name : publicIp_Address_name
  params:{
    publicIp_Address_name: publicIp_Address_name
    publicIp_Address_sku_name: publicIp_Address_sku_name
    publicIp_Address_sku_tier: publicIp_Address_sku_tier
  }
  
}

module managedClusters 'modules/aks-cluster.bicep' = {
name: managedClusters__name
params: {
  managedClusters__name: managedClusters__name
  virtualNetworks_externalid :vnet.outputs.vnetId
  publicIPAddresses: publicIp_Address.outputs.publicIP
  }
  dependsOn: [
    vnet
  ]
}





module dbServerName_resource_basket './modules/database.bicep' = {
  name: '${dbServerName}-basket'
  params:{
    dbAdministratorLogin: dbAdministratorLogin
    dbAdministratorLoginPassword: dbAdministratorLoginPassword
    dbServerName: '${dbServerName}-basket'
    dbServerVersion: dbServerVersion
    virtualNetworksvnet: vnet.outputs.vnetId
    subnetname: dbSubnetName
    privaedbdns: privatedns_basket.outputs.id
  }
  dependsOn: [
    vnet
    privatedns_basket
  ]
}

module privatedns_basket 'modules/databaseprivatedns.bicep' = {
  name: '${dbprivatednsname}-basket'
  params: {
    dbprivatednsname: '${dbprivatednsname}-basket.private.postgres.database.azure.com'
    dbprivatednsautoRegistration: dbprivatednsautoRegistration
    dbprivatednsvnId: vnet.outputs.vnetId
  }
  dependsOn: [
    vnet
  ]
}



module dbServerName_resource_core './modules/database.bicep' = {
  name: '${dbServerName}-core'
  params:{
    dbAdministratorLogin: dbAdministratorLogin
    dbAdministratorLoginPassword: dbAdministratorLoginPassword
    dbServerName: '${dbServerName}-core'
    dbServerVersion: dbServerVersion
    virtualNetworksvnet: vnet.outputs.vnetId
    subnetname: dbSubnetName
    privaedbdns: privatedns_core.outputs.id
  }
  dependsOn: [
    vnet
    privatedns_core
  ]
}

module privatedns_core 'modules/databaseprivatedns.bicep' = {
  name: '${dbprivatednsname}-core'
  params: {
    dbprivatednsname: '${dbprivatednsname}-core.private.postgres.database.azure.com'
    dbprivatednsautoRegistration: dbprivatednsautoRegistration
    dbprivatednsvnId: vnet.outputs.vnetId
  }
  dependsOn: [
    vnet
  ]
}


module dbServerName_resource_item './modules/database.bicep' = {
  name: '${dbServerName}-item'
  params:{
    dbAdministratorLogin: dbAdministratorLogin
    dbAdministratorLoginPassword: dbAdministratorLoginPassword
    dbServerName: '${dbServerName}-item'
    dbServerVersion: dbServerVersion
    virtualNetworksvnet: vnet.outputs.vnetId
    subnetname: dbSubnetName
    privaedbdns: privatedns_item.outputs.id
  }
  dependsOn: [
    vnet
    privatedns_item
  ]
}

module privatedns_item 'modules/databaseprivatedns.bicep' = {
  name: '${dbprivatednsname}-item'
  params: {
    dbprivatednsname: '${dbprivatednsname}-item.private.postgres.database.azure.com'
    dbprivatednsautoRegistration: dbprivatednsautoRegistration
    dbprivatednsvnId: vnet.outputs.vnetId
  }
  dependsOn: [
    vnet
  ]
}


module dbServerName_resource_receipt './modules/database.bicep' = {
  name: '${dbServerName}-receipt'
  params:{
    dbAdministratorLogin: dbAdministratorLogin
    dbAdministratorLoginPassword: dbAdministratorLoginPassword
    dbServerName: '${dbServerName}-receipt'
    dbServerVersion: dbServerVersion
    virtualNetworksvnet: vnet.outputs.vnetId
    subnetname: dbSubnetName
    privaedbdns: privatedns_receipt.outputs.id
  }
  dependsOn: [
    vnet
    privatedns_receipt
  ]
}

module privatedns_receipt 'modules/databaseprivatedns.bicep' = {
  name: '${dbprivatednsname}-receipt'
  params: {
    dbprivatednsname: '${dbprivatednsname}-receipt.private.postgres.database.azure.com'
    dbprivatednsautoRegistration: dbprivatednsautoRegistration
    dbprivatednsvnId: vnet.outputs.vnetId
  }
  dependsOn: [
    vnet
  ]
}


module dbServerName_resource_tender './modules/database.bicep' = {
  name: '${dbServerName}-tender'
  params:{
    dbAdministratorLogin: dbAdministratorLogin
    dbAdministratorLoginPassword: dbAdministratorLoginPassword
    dbServerName: '${dbServerName}-tender'
    dbServerVersion: dbServerVersion
    virtualNetworksvnet: vnet.outputs.vnetId
    subnetname: dbSubnetName
    privaedbdns: privatedns_tender.outputs.id
  }
  dependsOn: [
    vnet
    privatedns_tender
  ]
}

module privatedns_tender 'modules/databaseprivatedns.bicep' = {
  name: '${dbprivatednsname}-tender'
  params: {
    dbprivatednsname: '${dbprivatednsname}-tender.private.postgres.database.azure.com'
    dbprivatednsautoRegistration: dbprivatednsautoRegistration
    dbprivatednsvnId: vnet.outputs.vnetId
  }
  dependsOn: [
    vnet
  ]
}


module dbServerName_resource_txn './modules/database.bicep' = {
  name: '${dbServerName}-txn'
  params:{
    dbAdministratorLogin: dbAdministratorLogin
    dbAdministratorLoginPassword: dbAdministratorLoginPassword
    dbServerName: '${dbServerName}-txn'
    dbServerVersion: dbServerVersion
    virtualNetworksvnet: vnet.outputs.vnetId
    subnetname: dbSubnetName
    privaedbdns: privatedns_txn.outputs.id
  }
  dependsOn: [
    vnet
    privatedns_txn
  ]
}

module privatedns_txn 'modules/databaseprivatedns.bicep' = {
  name: '${dbprivatednsname}-txn'
  params: {
    dbprivatednsname: '${dbprivatednsname}-txn.private.postgres.database.azure.com'
    dbprivatednsautoRegistration: dbprivatednsautoRegistration
    dbprivatednsvnId: vnet.outputs.vnetId
  }
  dependsOn: [
    vnet
  ]
}





module virtualmachine 'modules/vm.bicep' = {
  name: vmName
  params: {
    vmSize: vmSize
    OSVersion: OSVersion
    vmName: vmName
    adminUsername: adminUsername
    adminPassword: adminPassword
    nicName: nicName
    nicsubnet: vnet.outputs.aksSubnetId
    publicnicIpName: publicnicIpName
  }
}
