param redisCacheName string
param redisfamily string 
param redisCacheType  string


resource redisCache 'Microsoft.Cache/Redis@2019-07-01' = {
  name: redisCacheName
  location: resourceGroup().location
  properties: {
    sku: {
      name: redisCacheType
      family: redisfamily
      capacity: 3
    }
  }
}
