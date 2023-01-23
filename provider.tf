provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.12.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.15.0"
    }
  }
  required_version = ">= 1.2.1"
  backend "azurerm" {
storage_account_name = "sapientassesnttfstatfile"
    container_name       = "ankucontainer"
    key                  = "ankur-poc.tfstate"
access_key="pJPCiw76h3nxLgfjILoikrYCYHbXx98nymgz7J99WsbgAWuiy24oO2GV9stN5RkjkogOWTo3bTJq+ASt/nZRkQ=="

}
}
