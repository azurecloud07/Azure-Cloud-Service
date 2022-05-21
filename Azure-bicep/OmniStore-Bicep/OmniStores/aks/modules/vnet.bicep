param virtualNetworkAddressPrefixes string
param aksSubnetName string
param aksSubnetAddressPrefix string
param dbSubnetName string
param dbSubnetAddressPrefix string

var subnetNsgName = '${resourceGroup().name}-nsg'
var vnetName = '${resourceGroup().name}-vnet'

resource subnetNsg 'Microsoft.Network/networkSecurityGroups@2020-07-01' = {
  name: subnetNsgName
  location: resourceGroup().location
  properties: {
    securityRules: [
      {
        name: 'AllowSshInbound'
        properties: {
          priority: 100
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '22'
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2020-05-01' = {
  name: vnetName
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        virtualNetworkAddressPrefixes
      ]
    }
    subnets: [
      {
        name: aksSubnetName
        properties: {
          addressPrefix: aksSubnetAddressPrefix
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Disabled'
        }
      }      
      {
        name: dbSubnetName
        properties: {
          addressPrefix: dbSubnetAddressPrefix
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Disabled' 
          delegations: [
            {
              name: 'dlg-Microsoft.DBforPostgreSQL-flexibleServers'
              properties: {
                serviceName: 'Microsoft.DBforPostgreSQL/flexibleServers'
              }
            }
          ]         
        }
      }
    ]
    enableDdosProtection: false
    enableVmProtection: false
  }
  dependsOn: [
    subnetNsg
  ]
}


output vnetId string = vnet.id

output aksSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, aksSubnetName)
output dbSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, dbSubnetName)
