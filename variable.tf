variable "resource_group_name" {
  description = "Resource Group Name"
  default="ankur-poc"
}

variable "team_name" {
  description = "This refers to team name. "
  default="sapient"
}

variable "team_number" {
  description = "The number of the team. eg: 10"
  default="10"
}

variable "app" {
  description = "This refers to resource application name. eg kafka"
  default="nginx"
}

variable "env" {
  description = "This refers to environment where it needs to be deployed. eg: dev, prod"
  default="dev"
}

variable "region" {
  description = "The name of the region to be installed"
  default="euw"
}

variable "location" {
  description = "This refers to location of azure infra"
  default="West Europe"
}

variable "subnet_name" {
  description = "subnet name"
  default="web-vnet"
}

variable "vnet_name" {
  description = "vnet rgroup"
  default="euw-vnet-poc"
}

variable "subnet_resouce_group_name" {
  description = "Subnet/VNET resource group name"
  default="ankur-poc"
}


variable "vmss_nsg_resource_group_name" {
  description = "Resource group name for NSG"
  default="ankur-poc"
}

variable "vmss_sku_name" {
  description = "VMSS SKU Name"
  default="Standard_DS1_v2"
}

variable "vmss_storage_disk_size" {
  description = "VMSS managed disk size in GB"
  default="16"
}

variable "vmss_admin_username" {
  description = "VMSS admin username"
  default="ankur"
}

variable "vmss_network_profile_name" {
  description = "VMSS Network profile and NIC name"
  default="euw-ankur-poc-nic"
}

variable "vmss_nsg" {
  description = "Name of NSG to be attached with VMSS"
  default="nginxweb-nsg"
}



variable "tags" {
  description = "tags"
  type        = map(any)
  default={
sub_type    = "dev"
team_number = "10"
team_name   = "sapient"
application = "ngnix"
}
}


