locals {
  config = yamldecode(file("${path.module}/values.yaml"))
}

data "terraform_remote_state" "bootstrap" {
  backend = "azurerm"

  config = {
    resource_group_name  = local.config.remote_state.resource_group_name
    storage_account_name = local.config.remote_state.storage_account_name
    container_name       = local.config.remote_state.container_name
    key                  = local.config.remote_state.bootstrap_key
    use_azuread_auth     = true
  }
}

module "resource_group" {
  source = "../../../modules/resource-group"

  name     = local.config.resource_group.name
  location = local.config.location
  tags     = local.config.tags
}

module "networking" {
  source = "../../../modules/networking"

  resource_group_name = module.resource_group.name
  location            = local.config.location
  tags                = local.config.tags
  config              = local.config.network
}
