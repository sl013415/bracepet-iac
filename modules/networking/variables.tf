variable "config" {
  description = "Networking module configuration loaded from the root stack YAML file."
  type = object({
    vnet_name     = string
    address_space = list(string)
    subnets = object({
      aks = object({
        name             = string
        address_prefixes = list(string)
      })
      postgres = object({
        name             = string
        address_prefixes = list(string)
      })
      private_endpoints = object({
        name             = string
        address_prefixes = list(string)
      })
    })
    enable_nat_gateway = bool
    private_dns_zones  = set(string)
  })

  validation {
    condition     = length(var.config.address_space) > 0
    error_message = "At least one VNet address space is required."
  }
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
