# Bastion
output "bastion_instance_ip_addr" {
    value = azurerm_public_ip.public_bastion.ip_address
}

# Backend
output "backend_instance_ip_addr" {
    value = azurerm_network_interface.nic_backend.private_ip_address
}

# Frontend
output "frontend_instance_ip_addr" {
    value = azurerm_network_interface.nic_frontend.private_ip_address
}