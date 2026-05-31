output "public_ips" {
  value       = azurerm_linux_virtual_machine.vm[*].public_ip_address
  description = "The Public IP addresses of the created VMs"
}

# एंसिबल कनेक्शन के लिए प्राइवेट की को स्क्रीन पर देखने के लिए
output "tls_private_key" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}

resource "local_file" "ssh_key_file" {
  filename        = "${path.module}/ansible_id_rsa.pem"
  content         = tls_private_key.ssh_key.private_key_pem
  file_permission = "0400" # यह विंडोज/लिनक्स पर फाइल को सिक्योर परमिशन (Read-Only) दे देगा
}