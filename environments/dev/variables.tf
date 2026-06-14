variable "resource_group_name" {
  type        = string
  default     = "ansible-tf-rg"
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  default     = "Central India"
  description = "Azure region for resources"
}

variable "vm_count" {
  type        = number
  default     = 1
  description = "Number of Ubuntu VMs to create"
}

variable "admin_username" {
  type        = string
  default     = "santosh_devops"
  description = "Administrator username for all VMs"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for VM login"
}