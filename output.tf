# Bastion
output "bastion_instance_ip_addr" {
    value = "ssh -i id_rsa adminuser@${azurerm_public_ip.public_bastion.ip_address}"
}

# Backend
output "backend_instance_ip_addr" {
    value = azurerm_network_interface.nic_backend.private_ip_address
}

# Frontend
output "frontend_instance_ip_addr" {
    value = azurerm_network_interface.nic_frontend.private_ip_address
}

output "application_gateway_dns" {
    value = azurerm_application_gateway.network.id
}