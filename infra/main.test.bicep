// This file is for doing static analysis and contains sensible defaults
// for the bicep analyser to minimise false-positives and provide the best results.

// This file is not intended to be used as a runtime configuration file.

targetScope = 'subscription'

// Reference to the resource group (required by template compliance)
resource testResourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg-${environmentName}'
  location: location
}

// Reference to Key Vault (required by template compliance)
module testKeyVault 'core/security/key-vault.bicep' = {
  name: 'test-key-vault'
  scope: testResourceGroup
  params: {
    name: 'kv-${environmentName}'
    location: location
    principalId: ''
  }
}

param environmentName string = 'testing'
param location string = 'westeurope'

module main 'main.bicep' = {
  name: 'main'
  params: {
    environmentName: environmentName
    location: location
    principalId: ''
  }
}
