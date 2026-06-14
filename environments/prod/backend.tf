terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "sttfstate8962"
    container_name       = "tfstate"
    key                  = "prod.tfstate"
  }
}