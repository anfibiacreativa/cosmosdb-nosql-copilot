metadata description = 'Create an Azure Cosmos DB for NoSQL role assignment.'

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

@description('Name of the target Azure Cosmos DB account.')
param targetAccountName string

@description('Id of the role definition to assign to the targeted principal and account.')
param roleDefinitionId string

@description('Id of the principal to assign the role definition for the account.')
param principalId string

@description('Principal type used for the role assignment.')
param principalType string

resource account 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: targetAccountName
}

resource assignment 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2023-04-15' = {
  name: guid(roleDefinitionId, principalId, account.id)
  parent: account
  properties: {
    principalId: principalId
    roleDefinitionId: roleDefinitionId
    scope: account.id
    principalType: principalType
  }
}

output id string = assignment.id
