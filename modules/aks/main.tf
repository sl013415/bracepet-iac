resource "azurerm_kubernetes_cluster" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version
  node_resource_group = var.node_resource_group

  sku_tier = "Free"

  role_based_access_control_enabled = true
  workload_identity_enabled          = var.workload_identity_enabled
  oidc_issuer_enabled               = var.oidc_issuer_enabled

  default_node_pool {
    name                 = var.default_node_pool.name
    node_count           = var.default_node_pool.node_count
    vm_size              = var.default_node_pool.vm_size
    os_disk_size_gb      = var.default_node_pool.os_disk_size_gb
    vnet_subnet_id       = var.subnet_id
    enable_auto_scaling  = var.default_node_pool.enable_auto_scaling
    min_count            = var.default_node_pool.min_count
    max_count            = var.default_node_pool.max_count
    orchestrator_version  = var.kubernetes_version
    only_critical_addons_enabled = false
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin     = var.network_plugin
    network_policy     = var.network_policy
    load_balancer_sku  = "standard"
    service_cidr       = var.service_cidr
    dns_service_ip     = var.dns_service_ip
    docker_bridge_cidr = var.docker_bridge_cidr
  }

  tags = var.tags
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
}
