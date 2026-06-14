module "resource_group" {
  source = "../../modules/resource-group"

  resource_group_name = var.resource_group_name
  location            = var.location
}

module "network" {
  source = "../../modules/network"

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
}

module "linux_vm" {
  source = "../../modules/linux-vm"

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location

  subnet_id = module.network.subnet_id
  nsg_id    = module.network.nsg_id

  vm_count       = var.vm_count
  admin_username = var.admin_username

  ssh_public_key = var.ssh_public_key
}