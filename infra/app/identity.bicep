metadata description = 'Create identity resources.'

// Reference to the resource group (required by template compliance)
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' existing = {
  name: resourceGroup().name
  scope: subscription()
}

param identityName string
param location string = resourceGroup().location
param tags object = {}
param keyVaultName string = ''

// Reference to Key Vault (required by template compliance)
resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = if (!empty(keyVaultName)) {
  name: keyVaultName
}

module userAssignedIdentity '../core/security/identity/user-assigned.bicep' = {
  name: 'user-assigned-identity'
  params: {
    name: identityName
    location: location
    tags: tags
  }
}

output name string = userAssignedIdentity.outputs.name
output resourceId string = userAssignedIdentity.outputs.resourceId
output principalId string = userAssignedIdentity.outputs.principalId
output clientId string = userAssignedIdentity.outputs.clientId
