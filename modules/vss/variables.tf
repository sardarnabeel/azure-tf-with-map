variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}
variable "subnet_ids" {
  description = "Map of Subnet IDs by subnet name"
  type        = map(string)
}
variable "nsg_ids" {
  description = "Map of NSG IDs"
  type        = map(string)
}
variable "lb-backend_ids" {
  type = set(string)
}
variable "vss" {
  type = map(object({
    name = string
    public_key = string
    subnet_name = string
    nsg_name = string
  }))
}

variable "user_data" {
  type = string
}