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

resource "azurerm_log_analytics_workspace" "this" {
  name                = local.config.monitoring.name
  location            = local.config.location
  resource_group_name = module.resource_group.name
  sku                 = "PerGB2018"
  retention_in_days   = local.config.monitoring.retention_in_days
  tags                = local.config.tags
}

module "acr" {
  source = "../../../modules/acr"

  name                = local.config.acr.name
  resource_group_name = module.resource_group.name
  location            = local.config.location
  sku                 = local.config.acr.sku
  admin_enabled       = local.config.acr.admin_enabled
  tags                = local.config.tags
}

module "aks" {
  source = "../../../modules/aks"

  name                = local.config.aks.name
  resource_group_name = module.resource_group.name
  location            = local.config.location
  dns_prefix          = local.config.aks.dns_prefix
  kubernetes_version  = local.config.aks.kubernetes_version
  subnet_id           = data.terraform_remote_state.network.outputs.aks_subnet_id
  acr_id              = module.acr.id
  node_resource_group = local.config.aks.node_resource_group

  default_node_pool = {
    name                = local.config.aks.default_node_pool.name
    node_count          = local.config.aks.default_node_pool.node_count
    vm_size             = local.config.aks.default_node_pool.vm_size
    os_disk_size_gb     = local.config.aks.default_node_pool.os_disk_size_gb
    enable_auto_scaling = local.config.aks.default_node_pool.enable_auto_scaling
    min_count           = local.config.aks.default_node_pool.min_count
    max_count           = local.config.aks.default_node_pool.max_count
  }

  network_plugin     = local.config.aks.network_plugin
  network_policy     = local.config.aks.network_policy
  service_cidr       = local.config.aks.service_cidr
  dns_service_ip     = local.config.aks.dns_service_ip
  docker_bridge_cidr = local.config.aks.docker_bridge_cidr
  workload_identity_enabled = local.config.aks.workload_identity_enabled
  oidc_issuer_enabled       = local.config.aks.oidc_issuer_enabled
  tags = local.config.tags
}

module "static_web_app" {
  source = "../../../modules/static-web-app"

  name                = local.config.static_web_app.name
  resource_group_name = module.resource_group.name
  location            = local.config.static_web_app.location
  sku_tier            = local.config.static_web_app.sku_tier
  sku_size            = local.config.static_web_app.sku_size
  tags                = local.config.tags
}
