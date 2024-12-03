variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}
variable "virtual_network_id" {
  type = map(string)
}
variable "subnet_ids" {
  description = "Map of Subnet IDs by subnet name"
  type        = map(string)
}
variable "mysql" {
  type = map(object({
    # name = string #db server name
    subnet_name = string
    vnet_name = string
    database_name = string
  }))
}