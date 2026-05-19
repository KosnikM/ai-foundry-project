variable "resource_group_name" {
  type    = string
  description = "group where resources will be deployed"
}

variable "location" {
    type = string
    description = "region where resources will be deployed"
}

variable "vnets" {
  type = map(object({
    address_space = list(string)
    subnets = map(object({
      address_prefix = string
    }))
  }))
  description = "Map of VNets with their address spaces and subnets to deploy"
}

variable "tags" {
  type = map(string)
}

