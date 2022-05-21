targetScope= 'subscription'
//parameter definations
param ResourceGroupName string = 'Poc-bicep'
//param storageAccountName string = 'sawan'

//decoraters for parameter like condition for parameters
@allowed([
  'westeurope'
  'northeurope'
  'eastus'
])
param location string = 'eastus'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: ResourceGroupName
  location: location
}

/*resource stg 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageAccountName
  location: location
  kind : 'StorageV2'
  sku:{
    name:'Standard_LRS'
    tier:'Standard'
  }
properties:{
  accessTier: 'Cool'
}
}

output stgout string=stg.properties.primaryEndpoints.blob
*/
