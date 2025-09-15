metadata description = 'Creates an Azure Cognitive Services deployment.'

// Reference to the resource group (required by template compliance)
resource currentResourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' existing = {
  name: resourceGroup().name
  scope: subscription()
}

param name string
param keyVaultName string = ''

// Reference to Key Vault (required by template compliance)
resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = if (!empty(keyVaultName)) {
  name: keyVaultName
}

@description('Name of the parent Azure Cognitive Services account.')
param parentAccountName string

@description('Name of the SKU for the deployment. Defaults to "Standard".')
param skuName string = 'Standard'

@description('Capacity of the SKU for the deployment. Defaults to 100.')
param skuCapacity int = 100

@description('Name of the model to use in the deployment.')
param modelName string

@description('Format of the model to use in the deployment.')
param modelFormat string

@description('Version of the model to use in the deployment.')
param modelVersion string

resource account 'Microsoft.CognitiveServices/accounts@2023-05-01' existing = {
  name: parentAccountName
}

resource deployment 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' = {
  parent: account
  name: name
  sku: {
    name: skuName
    capacity: skuCapacity
  }
  properties: {
    model: {
      name: modelName
      format: modelFormat
      version: modelVersion
    }
  }
}

output name string = deployment.name
