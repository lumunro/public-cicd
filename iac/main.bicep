param location string = resourceGroup().location
param storageAccountName string
param storageAccountSku object
param storageAccountAllowedNetworks array

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: storageAccountSku
  properties: {
    networkAcls: {
      ipRules: storageAccountAllowedNetworks
      defaultAction: 'Deny'
    }
    allowBlobPublicAccess: false
  }
}

resource blobServices 'Microsoft.Storage/storageAccounts/blobServices@2021-04-01' = {
  name: '${storageAccount.name}/default'
  properties: {
    changeFeed: {
      enabled: true
    }
    deleteRetentionPolicy: {
      enabled: true
      days: 31
    }
    containerDeleteRetentionPolicy: {
      enabled: true
      days: 31
    }
    restorePolicy: {
      enabled: true
      days: 30
    }
    isVersioningEnabled: true
  }
}

resource fileServices 'Microsoft.Storage/storageAccounts/fileServices@2021-04-01' = {
  name: '${storageAccount.name}/default'
  properties: {
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 31
    }
  }
}
