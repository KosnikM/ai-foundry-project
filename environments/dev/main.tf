resource "azurerm_resource_group" "networking" {
  name     = "rg-networking"
  location = local.location
  tags     = local.default_tags
}

resource "azurerm_resource_group" "security" {
  name     = "rg-security"
  location = local.location
  tags     = local.default_tags
}

resource "azurerm_resource_group" "compute" {
  name     = "rg-compute"
  location = local.location
  tags     = local.default_tags
}

resource "azurerm_resource_group" "monitoring" {
  name     = "rg-monitoring"
  location = local.location
  tags     = local.default_tags
}

resource "azurerm_resource_group" "governance" {
  name     = "rg-governance"
  location = local.location
  tags     = local.default_tags
}

resource "azurerm_resource_group" "ai" {
  name     = "rg-ai"
  location = "swedencentral"
  tags     = local.default_tags
}