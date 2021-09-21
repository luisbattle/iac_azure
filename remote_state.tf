terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraformstate"
    storage_account_name = "tfstoragestateaccount"
    container_name       = "tfstate"
    key                  = "testing.terraform.tfstate"
  }
}