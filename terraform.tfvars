rg-var = {
  resource_group_name = "nabeel-rg"
  location            = "West US 2"
}



vss = {
  "vss1" = {
    name        = "vss-name"
    public_key  = "/home/nabeel/.ssh/id_rsa.pub"
    subnet_name = "public-subnet"
    nsg_name    = "nsg1"
  }
}


mysql = {
  "mysql1" = {
    name          = "nabeel-fs"
    subnet_name   = "private-subnet"
    vnet_name     = "my-vnet1"
    database_name = "exampledb"
  }
}



# NSG Configuration
nsg_config = {
  "nsg1" = {}
  "nsg2" = {}
}



vnet_config = {
  "vnet1" = {
    vnet_name     = "my-vnet1"
    address_space = ["10.0.0.0/16"]
  }
  # "vnet2" = {
  #   vnet_name     = "my-vnet2"
  #   address_space = ["10.1.0.0/16"]
  # }
}

subnet_config = {
  "subnet1" = {
    subnet_name    = "public-subnet"
    vnet_key       = "vnet1"
    address_prefix = "10.0.1.0/24"
    Outbound       = true
  }
  "subnet2" = {
    subnet_name    = "private-subnet"
    vnet_key       = "vnet1"
    address_prefix = "10.0.2.0/24"
    Outbound       = false
  }
  # "subnet3" = {
  #   subnet_name    = "public-subnet2"
  #   vnet_key       = "vnet2"
  #   address_prefix = "10.1.1.0/24"
  #   Outbound     = false
  # }
}


lb_name = {
  lb_name = "example-nat-gateway"

}

nat-var = {
  nat_gateway_name = "example-nat-gateway"
}