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
  domain_name_label   = "devopstestaar"
}
locals {
  backend_address_pool_name      = "${azurerm_virtual_network.vnet_application.name}-frontend-beap"
  backend_address_api_pool_name  = "${azurerm_virtual_network.vnet_application.name}-api-beap"
  frontend_port_name             = "${azurerm_virtual_network.vnet_application.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.vnet_application.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.vnet_application.name}-be-htst"
  http_setting_api_name          = "${azurerm_virtual_network.vnet_application.name}-be-api-htst"
  listener_name                  = "${azurerm_virtual_network.vnet_application.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.vnet_application.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.vnet_application.name}-rdrcfg"
  url_path_map_name              = "${azurerm_virtual_network.vnet_application.name}-urlpath1"
  path_rule_name2                = "${azurerm_virtual_network.vnet_application.name}-pathrule2"
}

resource "azurerm_application_gateway" "network" {
  name                = "gtw-application-001"
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
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.agw-pip.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }
  
  backend_address_pool {
    name = local.backend_address_api_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 3000
    protocol              = "Http"
    request_timeout       = 60
  }

  backend_http_settings {
    name                  = local.http_setting_api_name
    cookie_based_affinity = "Disabled"
    path                  = "/api/"
    port                  = 3001
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
    rule_type                  = "PathBasedRouting"
    url_path_map_name          = local.url_path_map_name
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    # backend_http_settings_name = local.http_setting_name
  } 

  url_path_map {
    name                               = local.url_path_map_name
    default_backend_address_pool_name  = local.backend_address_pool_name
    default_backend_http_settings_name = local.http_setting_name

    path_rule {
      name                       = "agw-api-path-rule"
      paths                      = ["/api/*"]
      backend_address_pool_name  = local.backend_address_api_pool_name
      backend_http_settings_name = local.http_setting_api_name
    }
  }

}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "nic-beap-association-fe" {
  network_interface_id    = azurerm_network_interface.nic_frontend.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_application_gateway.network.backend_address_pool[0].id
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "nic-beap-association-be" {
  network_interface_id    = azurerm_network_interface.nic_backend.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_application_gateway.network.backend_address_pool[1].id
}
