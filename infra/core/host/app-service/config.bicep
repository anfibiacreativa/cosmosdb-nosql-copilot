metadata description = 'Creates an Azure App Service configuration for a site.'

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

@description('Name of the parent App Service site for the configuration.')
param parentSiteName string

@secure()
param appSettings object = {}

resource site 'Microsoft.Web/sites@2022-09-01' existing = {
  name: parentSiteName
}

resource config 'Microsoft.Web/sites/config@2022-09-01' = {
  name: 'appsettings'
  parent: site
  kind: 'string'
  properties: appSettings
}
