resource "azurerm_subnet" "frontend" {
  name                 = "frontend"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_application.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_public_ip" "agw-pip" {
  name                = "agw-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Dynamic"
}
locals {
  backend_address_pool_name      = "${azurerm_virtual_network.vnet_application.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.vnet_application.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.vnet_application.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.vnet_application.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.vnet_application.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.vnet_application.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.vnet_application.name}-rdrcfg"
}

resource "azurerm_application_gateway" "network" {
  name                = "example-appgateway"
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.frontend.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 3000
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.agw-pip.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 3000
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}