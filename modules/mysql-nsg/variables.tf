variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}


variable "nsg_config" {
  description = "Map of NSGs with configurations"
  type        = map(any)
}

