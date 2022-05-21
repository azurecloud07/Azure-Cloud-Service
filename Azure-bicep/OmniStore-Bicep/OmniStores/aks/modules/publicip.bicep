param publicIp_Address_name string
param publicIp_Address_sku_tier string
param publicIp_Address_sku_name string

resource publicIp_Address 'Microsoft.Network/publicIPAddresses@2021-08-01' = {
name : publicIp_Address_name

location: resourceGroup().location

sku: {
  name: publicIp_Address_sku_name
  tier: publicIp_Address_sku_tier
}
zones: [
  '1'
  '2'
  '3'
]
properties:{
  publicIPAddressVersion: 'IPv4'
  publicIPAllocationMethod: 'Static'
  idleTimeoutInMinutes: 30
}

}
output publicIP string = publicIp_Address.id
