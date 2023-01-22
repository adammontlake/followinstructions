terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.30.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  # default values for setting up the environment
  module_tag = {
    "module"    = "launchpad"
    "managedby" = "terraform"
  }
  tags             = merge(local.module_tag)
  location         = "eastus"
  environment      = "production"
  service_name     = "terraform"
  location-int     = "eastus"
  environment-int  = "integration"
  service_name-int = "terraform"
}

data "azurerm_resource_group" "rg" {
  name = "IaC_pipelines_rg"
}

module "storage_module" {
  source                  = "git::https://github.com/adammontlake/IaC-TF-pipe-demo.git//IaC/modules/storage"
  service_name            = "terraform"
  resource_group_name     = data.azurerm_resource_group.rg.name
  location                = data.azurerm_resource_group.rg.location
  account_tier            = "Standard"
  environment             = local.environment
  terraform_state_storage = false
  tags = {
    environment = "production"
    costcenter  = "it"
  }
}
