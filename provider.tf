# provider.tf

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#example-usage

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.64.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}
