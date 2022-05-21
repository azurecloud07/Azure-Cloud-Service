
param dbprivatednsname string
param dbprivatednsvnId string
param dbprivatednsautoRegistration bool 

resource privateDns 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: dbprivatednsname
  location: 'global'
}

resource vnLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${dbprivatednsname}/${dbprivatednsname}-link'
  location: 'global'
  properties: {
    registrationEnabled: dbprivatednsautoRegistration
    virtualNetwork: {
      id: dbprivatednsvnId
    }
  }
  dependsOn: [
    privateDns
  ]
}


output id string = privateDns.id
output name string = privateDns.name
