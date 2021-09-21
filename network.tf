# Create a virtual network 1 - Application GTW&Apps
resource "azurerm_virtual_network" "vnet_application" {
    name                = var.resource_virtual_network_application_name
    address_space       = var.resource_virtual_network_application_address_space
    location            = var.location
    resource_group_name = azurerm_resource_group.rg.name
}


# Create a Subnet1 for Backend
resource "azurerm_subnet" "subnet_backend" {
  name                 = var.resource_subnet_backend_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_application.name
  address_prefixes     = var.resource_subnet_backend_address_prefixes

}

# Create a Subnet2 for Frontend
resource "azurerm_subnet" "subnet_frontend" {
  name                 = var.resource_subnet_frontend_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_application.name
  address_prefixes     = var.resource_subnet_frontend_address_prefixes

}

# Create Virtual Interface for backend
resource "azurerm_network_interface" "nic_backend" {
  name                = "backend-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_backend.id
    private_ip_address_allocation = "Dynamic"
  }
}
# Create Virtual Interface for frontend
resource "azurerm_network_interface" "nic_frontend" {
  name                = "frontend-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_frontend.id
    private_ip_address_allocation = "Dynamic"
  }
}

#######################################
# Create a virtual network 2
#######################################
resource "azurerm_virtual_network" "vnet_bastion" {
    name                = var.resource_virtual_network_bastion_name
    address_space       = var.resource_virtual_network_bastion_address_space
    location            = var.location
    resource_group_name = azurerm_resource_group.rg.name
}

# Create a Subnet2
resource "azurerm_subnet" "subnet_bastion" {
  name                 = var.resource_subnet_bastion_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_bastion.name
  address_prefixes     = var.resource_subnet_bastion_address_prefixes

}

# Create Public IP Address
resource "azurerm_public_ip" "public_bastion" {
  name                = "public_bastion"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  allocation_method   = "Static"
}

# Create Virtual Interface
resource "azurerm_network_interface" "nic_bastion" {
  name                = "nic_bastion"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_bastion.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_bastion.id
  }
}
