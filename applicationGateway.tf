resource "azurerm_subnet" "subnet_applicationGateway" {
  name                 = var.resource_subnet_applicationGateway_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_application.name
  address_prefixes     = var.resource_subnet_applicationGateway_address_prefixes
}

resource "azurerm_public_ip" "appgtw-pip" {
  name                = "appgtw-pip"
  availability_zone   = "No-Zone"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard" 
}

# #&nbsp;since these variables are re-used - a locals block makes this more maintainable
# locals {
#   backend_address_pool_name      = "${var.resource_virtual_network_application_name}-beap"
#   frontend_port_name             = "${var.resource_virtual_network_application_name}-feport"
#   frontend_ip_configuration_name = "${var.resource_virtual_network_application_name}-feip"
#   http_setting_name              = "${var.resource_virtual_network_application_name}-be-htst"
#   listener_name                  = "${var.resource_virtual_network_application_name}-httplstn"
#   request_routing_rule_name      = "${var.resource_virtual_network_application_name}-rqrt"
#   redirect_configuration_name    = "${var.resource_virtual_network_application_name}-rdrcfg"
# }

# resource "azurerm_application_gateway" "network" {
#   name                = "appgateway"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = var.location
#   sku {
#     name     = "Standard_Small"
#     tier     = "Standard"
#     capacity = 1
#   }

#   gateway_ip_configuration {
#     name      = "my-gateway-ip-configuration"
#     subnet_id = azurerm_subnet.subnet_applicationGateway.id
#   }

#   frontend_port {
#     name = local.frontend_port_name
#     port = 3000
#   }

#   frontend_ip_configuration {
#     name                 = local.frontend_ip_configuration_name
#     public_ip_address_id = azurerm_public_ip.appgtw-pip.id
#   }

#   backend_address_pool {
#     name = local.backend_address_pool_name
#   }

#   backend_http_settings {
#     name                  = local.http_setting_name
#     cookie_based_affinity = "Disabled"
#     path                  = "/path1/"
#     port                  = 3000
#     protocol              = "Http"
#     request_timeout       = 60
#   }

#   http_listener {
#     name                           = local.listener_name
#     frontend_ip_configuration_name = local.frontend_ip_configuration_name
#     frontend_port_name             = local.frontend_port_name
#     protocol                       = "Http"
#   }

#   request_routing_rule {
#     name                       = local.request_routing_rule_name
#     rule_type                  = "Basic"
#     http_listener_name         = local.listener_name
#     backend_address_pool_name  = local.backend_address_pool_name
#     backend_http_settings_name = local.http_setting_name
#   }
# }