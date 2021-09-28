# TAGS
variable "project_name" {
  default = ""
}
variable "environment" {
  default = "development"
}
variable "location" {
  default = "eastus2"
}
# resource group
variable "resource_group_name" {
  default = "TFResourceGroupTraining"
}
# Virtual Network - Application Gateway&Apps
variable "resource_virtual_network_application_name" {
  default = "vnet_application" 
}
variable "resource_virtual_network_application_address_space" {
  default = ["10.0.0.0/16"]
}
# Subnet 1 of Vnet1
variable "resource_subnet_applicationGateway_name" {
    default = "subnet_applicationGateway"
}
variable "resource_subnet_applicationGateway_address_prefixes" {
    default = ["10.0.0.0/24"]
}
variable "resource_subnet_backend_name" {
    default = "subnet_backends"
}
variable "resource_subnet_backend_address_prefixes" {
    default = ["10.0.1.0/24"]
}
variable "resource_subnet_frontend_name" {
    default = "subnet_frontend"
}
variable "resource_subnet_frontend_address_prefixes" {
    default = ["10.0.2.0/24"]
}
# Virtual Network2 
variable "resource_virtual_network_bastion_name" {
  default = "vnet_bastion"
}
variable "resource_virtual_network_bastion_address_space" {
  default = ["11.0.0.0/16"]
}
# Subnet 1 of Vnet2
variable "resource_subnet_bastion_name" {
    default = "subnet_bastion"
}
variable "resource_subnet_bastion_address_prefixes" {
    default = ["11.0.1.0/24"]
}