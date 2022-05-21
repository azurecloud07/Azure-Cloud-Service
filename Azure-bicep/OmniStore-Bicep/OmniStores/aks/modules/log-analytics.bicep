param logAnalyticsSku string
param logAnalyticsRetentionInDays int

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: '${resourceGroup().name}-law'
  location: resourceGroup().location
  properties: {
    sku: {
      name: logAnalyticsSku
    }
    retentionInDays: logAnalyticsRetentionInDays
  }
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: '${resourceGroup().name}-insights'
  location: resourceGroup().location
  kind: 'web'
  properties:{
    Application_Type:'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}

output Id string = logAnalyticsWorkspace.id
output InstrumentationKey string = appInsights.properties.InstrumentationKey
