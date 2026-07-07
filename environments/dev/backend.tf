terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "sttfstatemkproject2"
    container_name       = "tfstate"
    key                  = "dev.tfstate"
  }
}