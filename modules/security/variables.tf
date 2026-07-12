variable "resource_group_name" {
  type        = string
  description = "RG where security resources will be deployed"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "tags" {
  type        = map(string)
  description = "Tags for all resources"
}

variable "hub_vnet_id" {
  type        = string
  description = "Hub VNet ID for Bastion deployment"
}

variable "firewall_subnet_id" {
  type        = string
  description = "AzureFirewallSubnet ID"
}

variable "bastion_subnet_id" {
  type        = string
  description = "AzureBastionSubnet ID"
}

variable "spoke_subnet_ids" {
  type        = list(string)
  description = "List of spoke subnet IDs to attach Route Table"
}

variable "firewall_private_ip" {
  type        = string
  description = "Private IP of Azure Firewall for Route Table next hop"
  default     = "10.0.1.4"
}

variable "jumpbox_subnet_id" {
  type        = string
  description = "Jumpbox subnet ID"
}

variable "jumpbox_admin_password" {
  type        = string
  sensitive   = true
  description = "Admin password for Jump Box VM"
}