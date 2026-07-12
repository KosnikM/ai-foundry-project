output "vnets_id" {
  description = "vnet_ids:"
  value       = { for x, y in azurerm_virtual_network.this : x => y.id }
}
output "subnet_ids" {
  description = "subnet_ids:"
  value       = { for x, y in azurerm_subnet.this : x => y.id }
}