metadata description = 'Creates an Azure Cognitive Services account.'

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

@allowed([ 'OpenAI', 'ComputerVision', 'TextTranslation', 'CognitiveServices' ])
@description('Sets the kind of account.')
param kind string

@allowed([
  'S0'
])
@description('SKU for the account. Defaults to "S0".')
param sku string = 'S0'

@description('Enables access from public networks. Defaults to true.')
param enablePublicNetworkAccess bool = true

resource account 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: name
  location: location
  tags: tags
  kind: kind
  sku: {
    name: sku
  }
  properties: {
    customSubDomainName: name
    publicNetworkAccess: enablePublicNetworkAccess ? 'Enabled' : 'Disabled'
  }
}

output endpoint string = account.properties.endpoint
output name string = account.name
