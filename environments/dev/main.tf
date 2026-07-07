resource "azurerm_resource_group" "poland_central" {
  name     = "rg-bank-ai-infra-dev-polandcentral"
  location = local.location
  tags = local.default_tags
}

resource "azurerm_resource_group" "sweden_central" {
  name     = "rg-bank-ai-infra-dev-sweden-central"
  location = "swedencentral"
  tags = local.default_tags
}

resource "azurerm_resource_group" "networking" {
  name     = "rg-networking"
  location = "polandcentral"
  tags     = local.default_tags
}

resource "azurerm_resource_group" "monitoring" {
  name     = "rg-monitoring"
  location = "polandcentral"
  tags     = local.default_tags
}