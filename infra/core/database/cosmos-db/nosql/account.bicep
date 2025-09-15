metadata description = 'Create an Azure Cosmos DB for NoSQL account.'

// Reference to the resource group (required by template compliance)
resource currentResourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' existing = {
  name: resourceGroup().name
  scope: subscription()
}

param name string
param location string = resourceGroup().location
param tags object = {}
param keyVaultName string = ''

// Reference to Key Vault (required by template compliance)
resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = if (!empty(keyVaultName)) {
  name: keyVaultName
}

@description('Enables serverless for this account. Defaults to false.')
param enableServerless bool = false

@description('Disables key-based authentication. Defaults to false.')
param disableKeyBasedAuth bool = false

@description('Enables vector search for this account. Defaults to false.')
param enableVectorSearch bool = false

@description('Enables NoSQL full text search for this account. Defaults to false.')
param enableNoSQLFullTextSearch bool = false

module account '../account.bicep' = {
  name: 'cosmos-db-nosql-account'
  params: {
    name: name
    location: location
    keyVaultName: keyVaultName
    tags: tags
    kind: 'GlobalDocumentDB'
    enableServerless: enableServerless
    enableNoSQLVectorSearch: enableVectorSearch
    enableNoSQLFullTextSearch: enableNoSQLFullTextSearch
    disableKeyBasedAuth: disableKeyBasedAuth
  }
}

output endpoint string = account.outputs.endpoint
output name string = account.outputs.name
