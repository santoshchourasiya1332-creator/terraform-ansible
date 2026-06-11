output "public_ips" {
  value = module.linux_vm.public_ips
}

output "tls_private_key" {
  value     = module.linux_vm.private_key
  sensitive = true
}