param StorageAccountName string

resource StorageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: StorageAccountName
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}



resource os_ui_blobServicesstorageAccounts 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-09-01' = {
  name: '${StorageAccount.name}/default/os-ui'
  dependsOn: [
    StorageAccount
  ]
}


resource filesharestorageAccounts 'Microsoft.Storage/storageAccounts/fileServices/shares@2021-09-01' = {
  name: '${StorageAccount.name}/default/demo'
  properties: {
    accessTier: 'TransactionOptimized'
    shareQuota: 5120
    enabledProtocols: 'SMB'
  }
  dependsOn: [
    StorageAccount
  ]
}
