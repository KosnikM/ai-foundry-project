variable "resource_group_name" {
  type        = string
  description = "group where resources will be deployed"
}

variable "location" {
  type        = string
  description = "region where resources will be deployed"
}

variable "vnets" {
  type = map(object({
    address_space = list(string)
    subnets = map(object({
      address_prefix = string
      nsg_rules = list(object({
        name                       = string
        priority                   = number
        direction                  = string
        access                     = string
        protocol                   = string
        source_port_range          = string
        destination_port_range     = string
        source_address_prefix      = string
        destination_address_prefix = string
      }))
    }))
  }))
  description = "Map of VNets with their address spaces and subnets to deploy"
}

variable "tags" {
  type = map(string)
}

variable "private_dns_zones" {
  type        = list(string)
  description = "List of private DNS zone names to create in hub VNet"
}