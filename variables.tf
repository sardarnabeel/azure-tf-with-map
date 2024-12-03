variable "rg-var" {
  type = object({
    location            = string
    resource_group_name = string
  })
}

#------mysql-server-------#

variable "mysql" {
  type = map(object({
    # name = string #db server name
    subnet_name   = string
    vnet_name     = string
    database_name = string
  }))
}


#----------vss----------#
variable "vss" {
  type = map(object({
    name        = string
    public_key  = string
    subnet_name = string
    nsg_name    = string
  }))
}
#-------------mysql-nsg---------#
variable "nsg_config" {
  description = "Map of NSGs with configurations"
  type        = map(any)
}



#---------vnet-----------#

variable "vnet_config" {
  description = "Map of Virtual Network configurations"
  type = map(object({
    vnet_name     = string
    address_space = list(string)
  }))
}

variable "subnet_config" {
  description = "Map of Subnet configurations"
  type = map(object({
    subnet_name    = string
    vnet_key       = string
    address_prefix = string
    Outbound       = bool
  }))
}
#------------- Load balancer -------------- #
variable "lb_name" {
  type = object({
    lb_name = string
  })
}

#-----------nat-gateway---------#
variable "nat-var" {
  type = object({
    nat_gateway_name = string
  })
}
