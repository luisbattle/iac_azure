
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
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCYa6/AsuTtUMXqbGjUyGkBikfy+ucucDACNdkTDnfVHhxhG1Of6/TgMbvJPBMPc3J6oHhspzeq2ZBZHUUEGqrmtiPPoH+g27SwsGpvfxEQPRmGdECyFFBgAppJXGihe4oguDXTpC22WlC53VCy64s6VT+DqS3V26BV2y4Bn+GQDgk0NUfmSsgQfQcayBsoHOq+7+y5xI5BKglF1CrZlVF74u1umgbLgkDNZkkEJrfcFmZONhjNTcbtYEO+3U4tHwlh954g3MqqJswYn42lGt0DJ6oSa3/0xxj6ovsQWCWjOwf9ktIglHjB5tY9naM5xYAEtBpoxd0Mp9PzlsrMlTz5uMldh+W+NeO7qlzW1bC9IKysxMvu8bWw/7chZMRhoC2R16qZL78KAopU+0umnySLc5j+Cy6Xj/jJOpcG57S827lnfqOaEfscpoogRb+iGgPA+RMeRoBBg/BfGS41LxkV6ON4pTN4L4tX8bVyUP8IrE5/x/oDa5vYUjjEwnPE/0mROhfM+76XUTDiFUShBj+L92tk46huHJ/AQ5wwTq7ncR+A91z6oIFbPW0Gd1g3bKTqUrMV2EcV7tERhCfyoS8eh4HavwfceMOSjYSN8eUXQKnf+aPuc5flPmFzoMJSiJim4ui7PMLulNOKbjYo9CQHXaZJedWxVVQIYvPreVwlAw== lbatalla@ASUS-TUF"
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
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCYa6/AsuTtUMXqbGjUyGkBikfy+ucucDACNdkTDnfVHhxhG1Of6/TgMbvJPBMPc3J6oHhspzeq2ZBZHUUEGqrmtiPPoH+g27SwsGpvfxEQPRmGdECyFFBgAppJXGihe4oguDXTpC22WlC53VCy64s6VT+DqS3V26BV2y4Bn+GQDgk0NUfmSsgQfQcayBsoHOq+7+y5xI5BKglF1CrZlVF74u1umgbLgkDNZkkEJrfcFmZONhjNTcbtYEO+3U4tHwlh954g3MqqJswYn42lGt0DJ6oSa3/0xxj6ovsQWCWjOwf9ktIglHjB5tY9naM5xYAEtBpoxd0Mp9PzlsrMlTz5uMldh+W+NeO7qlzW1bC9IKysxMvu8bWw/7chZMRhoC2R16qZL78KAopU+0umnySLc5j+Cy6Xj/jJOpcG57S827lnfqOaEfscpoogRb+iGgPA+RMeRoBBg/BfGS41LxkV6ON4pTN4L4tX8bVyUP8IrE5/x/oDa5vYUjjEwnPE/0mROhfM+76XUTDiFUShBj+L92tk46huHJ/AQ5wwTq7ncR+A91z6oIFbPW0Gd1g3bKTqUrMV2EcV7tERhCfyoS8eh4HavwfceMOSjYSN8eUXQKnf+aPuc5flPmFzoMJSiJim4ui7PMLulNOKbjYo9CQHXaZJedWxVVQIYvPreVwlAw== lbatalla@ASUS-TUF"
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
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCYa6/AsuTtUMXqbGjUyGkBikfy+ucucDACNdkTDnfVHhxhG1Of6/TgMbvJPBMPc3J6oHhspzeq2ZBZHUUEGqrmtiPPoH+g27SwsGpvfxEQPRmGdECyFFBgAppJXGihe4oguDXTpC22WlC53VCy64s6VT+DqS3V26BV2y4Bn+GQDgk0NUfmSsgQfQcayBsoHOq+7+y5xI5BKglF1CrZlVF74u1umgbLgkDNZkkEJrfcFmZONhjNTcbtYEO+3U4tHwlh954g3MqqJswYn42lGt0DJ6oSa3/0xxj6ovsQWCWjOwf9ktIglHjB5tY9naM5xYAEtBpoxd0Mp9PzlsrMlTz5uMldh+W+NeO7qlzW1bC9IKysxMvu8bWw/7chZMRhoC2R16qZL78KAopU+0umnySLc5j+Cy6Xj/jJOpcG57S827lnfqOaEfscpoogRb+iGgPA+RMeRoBBg/BfGS41LxkV6ON4pTN4L4tX8bVyUP8IrE5/x/oDa5vYUjjEwnPE/0mROhfM+76XUTDiFUShBj+L92tk46huHJ/AQ5wwTq7ncR+A91z6oIFbPW0Gd1g3bKTqUrMV2EcV7tERhCfyoS8eh4HavwfceMOSjYSN8eUXQKnf+aPuc5flPmFzoMJSiJim4ui7PMLulNOKbjYo9CQHXaZJedWxVVQIYvPreVwlAw== lbatalla@ASUS-TUF"
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