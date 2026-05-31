variable "resource_group_name" {
  type        = string
  default     = "ansible-tf-rg"
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  default     = "East Asia"
  description = "Azure region for resources"
}

variable "vm_count" {
  type        = number
  default     = 2
  description = "Number of Ubuntu VMs to create"
}

variable "admin_username" {
  type        = string
  default     = "santosh_devops"
  description = "Administrator username for all VMs"
}