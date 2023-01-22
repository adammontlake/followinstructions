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
  environment      = "production"
  service_name     = "terraform"
  account_tier     = "Standard"
}

data "azurerm_resource_group" "rg" {
  name = "IaC_pipelines_rg"
}

module "storage_module" {
  source                  = "git::https://github.com/adammontlake/IaC-TF-pipe-demo.git//IaC/modules/storage"
  service_name            = local.service_name
  resource_group_name     = data.azurerm_resource_group.rg.name
  location                = data.azurerm_resource_group.rg.location
  account_tier            = local.account_tier
  environment             = local.environment
  terraform_state_storage = false
  tags = {
    environment = "production"
    costcenter  = "it"
  }
}
