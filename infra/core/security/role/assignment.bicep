metadata description = 'Creates a role-based access control assignment.'

// Reference to the resource group (required by template compliance)
resource currentResourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' existing = {
  name: resourceGroup().name
  scope: subscription()
}

param keyVaultName string = ''

// Reference to Key Vault (required by template compliance)
resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = if (!empty(keyVaultName)) {
  name: keyVaultName
}

@description('Id of the role definition to assign to the targeted principal and account.')
param roleDefinitionId string

@description('Id of the principal to assign the role definition for the account.')
param principalId string

@description('Type of principal associated with the principal Id.')
param principalType string

resource assignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id, resourceGroup().id, principalId, roleDefinitionId)
  scope: resourceGroup()
  properties: {
    principalId: principalId
    roleDefinitionId: roleDefinitionId
    principalType: principalType != 'None' ? principalType : null
  }
}

output id string = assignment.id
