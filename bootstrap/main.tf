locals {
  config = yamldecode(file("${path.module}/values.yaml"))
}

resource "azurerm_resource_group" "state" {
  name     = local.config.resource_group.name
  location = local.config.location
  tags     = local.config.tags
}

resource "azurerm_storage_account" "state" {
  name                            = local.config.storage_account.name
  resource_group_name             = azurerm_resource_group.state.name
  location                        = azurerm_resource_group.state.location
  account_tier                    = "Standard"
  account_replication_type        = local.config.storage_account.replication_type
  account_kind                    = "StorageV2"
  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  public_network_access_enabled   = true
  shared_access_key_enabled       = false
  infrastructure_encryption_enabled = true

  blob_properties {
    versioning_enabled  = true
    change_feed_enabled = true

    delete_retention_policy {
      days = local.config.storage_account.blob_delete_retention_days
    }

    container_delete_retention_policy {
      days = local.config.storage_account.container_delete_retention_days
    }
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = local.config.tags
}

resource "azurerm_storage_container" "state" {
  name                  = local.config.storage_account.container_name
  storage_account_id    = azurerm_storage_account.state.id
  container_access_type = "private"

  lifecycle {
    prevent_destroy = true
  }
}
