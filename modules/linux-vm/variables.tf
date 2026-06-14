variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "nsg_id" {
  type = string
}

variable "vm_count" {
  type = number
}

variable "admin_username" {
  type = string
}

variable "ssh_public_key" {
  type = string
}