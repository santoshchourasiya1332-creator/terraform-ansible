output "public_ips" {
  value = azurerm_linux_virtual_machine.vm[*].public_ip_address
}

output "private_key" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}