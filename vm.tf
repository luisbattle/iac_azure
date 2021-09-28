
# Create backend
resource "azurerm_virtual_machine" "backend" {
  name                = "vm-backend"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  vm_size                = "Standard_B1ls"
  network_interface_ids = [
    azurerm_network_interface.nic_backend.id,
  ]

  os_profile {
    computer_name = "vm-backend"
    admin_username = "adminuser"
    custom_data = base64encode(data.template_file.linux-backend-cloud-init.rendered)
  }
  
  os_profile_linux_config {
    disable_password_authentication = "true"
    ssh_keys {
      path = "/home/adminuser/.ssh/authorized_keys"
      key_data = file("./id_rsa.pub")
    }
  }

  storage_os_disk {
    name              = "os_disk_backend"
    caching              = "ReadWrite"
    managed_disk_type  = "Standard_LRS"
    create_option     = "FromImage"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

# Create frontend
resource "azurerm_virtual_machine" "frontend" {
  name                = "vm-frontend"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  vm_size                = "Standard_B2s"
  network_interface_ids = [
    azurerm_network_interface.nic_frontend.id,
  ]

  os_profile {
    computer_name = "vm-frontend"
    admin_username = "adminuser"
    custom_data = base64encode(data.template_file.linux-frontend-cloud-init.rendered)
  }
  
  os_profile_linux_config {
    disable_password_authentication = "true"
    ssh_keys {
      path = "/home/adminuser/.ssh/authorized_keys"
      key_data = file("./id_rsa.pub")
    }
  }

  storage_os_disk {
    name              = "os_disk_frontend"
    caching              = "ReadWrite"
    managed_disk_type  = "Standard_LRS"
    create_option     = "FromImage"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

# Create Bastion host
resource "azurerm_linux_virtual_machine" "bastion" {
  name                = "vm-bastion"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  size                = "Standard_B1ls"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.nic_bastion.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("./id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}