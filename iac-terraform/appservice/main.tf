provider "azurerm" {
    # The "feature" block is required for AzureRM provider 2.x.
    # If you're using version 1.x, the "features" block is not allowed.
    version = "~>2.0"
    features {}
}

terraform {
  backend "azurerm" {}
}
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "resource_group_terraform" {
  name     = "rg_terraformdemo"
  location = "Brazil South"
}

resource "azurerm_app_service_plan" "app_service_plan_terraform" {
  name                = "sp_terraform"
  location            = azurerm_resource_group.resource_group_terraform.location
  resource_group_name = azurerm_resource_group.resource_group_terraform.name

  sku {
    tier = "Standard"
    size = "S3"
  }
}

resource "azurerm_app_service" "app_service_terraform" {
  name                = "app-terraform-democlear"
  location            = azurerm_resource_group.resource_group_terraform.location
  resource_group_name = azurerm_resource_group.resource_group_terraform.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan_terraform.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "SOME_KEY" = "chavexpto"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}