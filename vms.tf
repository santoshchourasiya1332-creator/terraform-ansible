# 1. ऑटोमैटिक SSH Key जनरेट करने के लिए
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4000
}

# 2. 3 पब्लिक आईपी बनाना (Standard SKU और Static Allocation के साथ)
resource "azurerm_public_ip" "pip" {
  count               = var.vm_count
  name                = "ansible-vm-pip-${count.index + 1}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  
  sku               = "Standard"
  allocation_method = "Static"

  ddos_protection_mode = "VirtualNetworkInherited"
}

# 3. 3 नेटवर्क इंटरफेस कार्ड (NIC) बनाना और उन्हें NSG से जोड़ना
resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "ansible-vm-nic-${count.index + 1}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[count.index].id
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg_assoc" {
  count                     = var.vm_count
  network_interface_id      = azurerm_network_interface.nic[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# 4. 3 Ubuntu Linux Virtual Machines (पोर्टल इमेज के हिसाब से फिक्स किया हुआ)
resource "azurerm_linux_virtual_machine" "vm" {
  count               = var.vm_count
  name                = "ansible-node-${count.index + 1}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_D2s_v3"
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.ssh_key.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # यहाँ हमने इमेज पाथ को पोर्टल के अनुसार बदल दिया है
  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}