metadata description = 'Creates a Microsoft Entra user-assigned identity.'

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

resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: name
  location: location
  tags: tags
}

output name string = identity.name
output resourceId string = identity.id
output principalId string = identity.properties.principalId
output clientId string = identity.properties.clientId
output tenantId string = identity.properties.tenantId
