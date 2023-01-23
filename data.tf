locals {
  resource_name_prefix = "${var.region}-${var.env}-${var.team_number}-${var.team_name}-${var.app}"
}

data "azurerm_subnet" "lb_subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.subnet_resouce_group_name
}


data "azurerm_network_security_group" "vmss_nsg" {
  name                = "nginxweb-nsg"
  resource_group_name = "ankur-poc"
}

