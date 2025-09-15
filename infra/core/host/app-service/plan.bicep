metadata description = 'Creates an Azure App Service plan.'

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

@allowed([
  'linux'
])
@description('OS type of the plan. Defaults to "linux".')
param kind string = 'linux'


@description('SKU for the plan. Defaults to "F1".')
param sku string = 'F1'

resource plan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: sku
  }
  kind: kind
  properties: {
    reserved: kind == 'linux' ? true : null
  }
}

output name string = plan.name
