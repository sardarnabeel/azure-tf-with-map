variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Resource Group"
  type        = string
}

variable "vnet_config" {
  description = "Map of Virtual Network configurations"
  type = map(object({
    vnet_name      = string
    address_space  = list(string)
  }))
}

variable "subnet_config" {
  description = "Map of Subnet configurations"
  type = map(object({
    subnet_name   = string
    vnet_key      = string
    address_prefix = string
    Outbound      = bool
  }))
}