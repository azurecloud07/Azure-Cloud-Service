param dbServerName string 
param dbAdministratorLogin string
param subnetname string
param privaedbdns string

@secure()
param dbAdministratorLoginPassword string
param dbServerVersion string 



param virtualNetworksvnet string


resource flexiblepostgreServer 'Microsoft.DBforPostgreSQL/flexibleServers@2021-06-01' = {
  name: dbServerName
  location: resourceGroup().location

  sku: {
    name: 'Standard_B1ms'
    tier: 'Burstable'
  }
  properties: {
    version: dbServerVersion
    administratorLogin: dbAdministratorLogin
    administratorLoginPassword: dbAdministratorLoginPassword
    availabilityZone: '1'
    storage: {
      storageSizeGB: 32
    }
    backup: {
      backupRetentionDays: 7
      geoRedundantBackup: 'Disabled'
    }
    network: {
      delegatedSubnetResourceId: '${virtualNetworksvnet}/subnets/${subnetname}'
      privateDnsZoneArmResourceId: privaedbdns
    }
    highAvailability: {
      mode: 'Disabled'
    }
    maintenanceWindow: {
      customWindow: 'Disabled'
      dayOfWeek: 0
      startHour: 0
      startMinute: 0
    }
  }
}

