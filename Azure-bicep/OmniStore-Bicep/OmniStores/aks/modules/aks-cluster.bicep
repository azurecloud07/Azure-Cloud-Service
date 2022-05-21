param managedClusters__name string
param virtualNetworks_externalid string 
param publicIPAddresses string

resource managedClusters_name_resource 'Microsoft.ContainerService/managedClusters@2022-02-02-preview' = {
  name: managedClusters__name
  location: resourceGroup().location
  sku: {
    name: 'Basic'
    tier: 'Paid'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    kubernetesVersion: '1.21.9'
    dnsPrefix: '${managedClusters__name}-dns'
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 1
        vmSize: 'Standard_D16s_v4'
        osDiskSizeGB: 128
        osDiskType: 'Managed'
        kubeletDiskType: 'OS'
        vnetSubnetID: '${virtualNetworks_externalid}/subnets/AksSubnet'
        maxPods: 110
        type: 'VirtualMachineScaleSets'
        availabilityZones: [
          '1'
          '2'
          '3'
        ]
        maxCount: 2
        minCount: 1
        enableAutoScaling: true
        powerState: {
          code: 'Running'
        }
        orchestratorVersion: '1.21.9'
        enableNodePublicIP: false
        
        mode: 'System'
        osType: 'Linux'
        osSKU: 'Ubuntu'
        enableFIPS: false
      }
    ]
    
    addonProfiles: {
      azureKeyvaultSecretsProvider: {
        enabled: false
      }
      azurepolicy: {
        enabled: false
      }
    }
    nodeResourceGroup: 'MC_demo-omnistore_${managedClusters__name}_eastus'
    enableRBAC: false
    networkProfile: {
      networkPlugin: 'azure'
      loadBalancerSku: 'Standard'
      loadBalancerProfile: {
        managedOutboundIPs: {
          count: 1
        }
        effectiveOutboundIPs: [
          {
            id: publicIPAddresses
          }
        ]
      }
    }
  }
}

output aksID string = managedClusters_name_resource.id
