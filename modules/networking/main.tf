
# Flatten nested map (vnets -> subnets) into a flat map for for_each.
# Key: "vnet_key-subnet_key" ensures uniqueness across all vnets.
resource "azurerm_virtual_network" "this" {
  for_each            = var.vnets
  name                = "vn-bank-ai-infra-${each.key}-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = each.value.address_space
  tags                = var.tags
}


locals {
  subnets = flatten([
    for vnet_key, vnet in var.vnets : [
      for subnet_key, subnet in vnet.subnets : {
        vnet_key       = vnet_key
        subnet_key     = subnet_key
        address_prefix = subnet.address_prefix
      }
    ]
  ])
}
resource "azurerm_subnet" "this" {
  for_each             = { for s in local.subnets : "${s.vnet_key}-${s.subnet_key}" => s }
  name                 = each.value.subnet_key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this[each.value.vnet_key].name
  address_prefixes     = [each.value.address_prefix]
}

resource "azurerm_network_security_group" "this" {
  for_each = { for s in local.subnets : "${s.vnet_key}-${s.subnet_key}" => s }
  name                = "${each.key}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags = var.tags
    dynamic "security_rule" {
     for_each = each.value.nsg_rules
  content {
    name = security_rule.value.name
    priority                   = security_rule.value.priority
    direction                  = security_rule.value.direction
    access                     = security_rule.value.access
    protocol                   = security_rule.value.protocol
    source_port_range          = security_rule.value.source_port_range
    destination_port_range     = security_rule.value.destination_port_range
    source_address_prefix      = security_rule.value.source_address_prefix
    destination_address_prefix = security_rule.value.destination_address_prefix
  }
    }
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = { for s in local.subnets : "${s.vnet_key}-${s.subnet_key}" => s }
  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = azurerm_network_security_group.this[each.key].id
}

resource "azurerm_virtual_network_peering" "hub-spoke" {
  name = "peer-hub-to-spoke"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this["hub"].name
  remote_virtual_network_id = azurerm_virtual_network.this["spoke"].id
  allow_forwarded_traffic = true
  allow_gateway_transit = false
}

resource "azurerm_virtual_network_peering" "spoke-hub" {
  name = "peer-spoke-to-hub"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this["spoke"].name
  remote_virtual_network_id = azurerm_virtual_network.this["hub"].id
  allow_forwarded_traffic = true
  allow_gateway_transit = false
}

resource "azurerm_virtual_network_peering" "hub-ai" {
  name = "peer-hub-to-ai"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this["hub"].name
  remote_virtual_network_id = azurerm_virtual_network.this["ai"].id
  allow_forwarded_traffic = true
  allow_gateway_transit = false
}

resource "azurerm_virtual_network_peering" "ai-hub" {
  name = "peer-ai-to-hub"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this["ai"].name
  remote_virtual_network_id = azurerm_virtual_network.this["hub"].id
  allow_forwarded_traffic = true
  allow_gateway_transit = false
}

resource "azurerm_private_dns_zone" "this" {
    for_each = toset(var.private_dns_zones)
    name = each.key
  resource_group_name = var.resource_group_name
  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each = toset(var.private_dns_zones)  
  name = "link-${each.key}"
  resource_group_name = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this[each.key].name
  virtual_network_id = azurerm_virtual_network.this["hub"].id
}