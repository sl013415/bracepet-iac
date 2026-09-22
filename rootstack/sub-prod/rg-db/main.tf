variable "postgres_admin_password" {
  description = "The PostgreSQL Flexible Server admin password. Use Azure Key Vault or environment variables in CI/CD."
  type        = string
  sensitive   = true
}

locals {
  config = yamldecode(file("${path.module}/values.yaml"))
}

data "terraform_remote_state" "network" {
  backend = "azurerm"

  config = {
    resource_group_name  = local.config.remote_state.resource_group_name
    storage_account_name = local.config.remote_state.storage_account_name
    container_name       = local.config.remote_state.container_name
    key                  = local.config.remote_state.network_key
    use_azuread_auth     = true
  }
}

module "resource_group" {
  source = "../../../modules/resource-group"

  name     = local.config.resource_group.name
  location = local.config.location
  tags     = local.config.tags
}

module "postgres" {
  source = "../../../modules/postgres-flexible-server"

  name                   = local.config.postgres.name
  resource_group_name    = module.resource_group.name
  location               = local.config.location
  version                = local.config.postgres.version
  administrator_login    = local.config.postgres.administrator_login
  administrator_password = var.postgres_admin_password
  sku_name               = local.config.postgres.sku_name
  storage_mb             = local.config.postgres.storage_mb
  backup_retention_days  = local.config.postgres.backup_retention_days
  delegated_subnet_id    = data.terraform_remote_state.network.outputs.postgres_subnet_id
  private_dns_zone_id    = data.terraform_remote_state.network.outputs.private_dns_zone_ids["privatelink.postgres.database.azure.com"]
  public_network_access_enabled = false
  tags = local.config.tags
  database_name = local.config.postgres.database_name
}
