module "resource_group" {
  source = "./modules/resource_group"
  rg-var = var.rg-var
}
module "vss" {
  source              = "./modules/vss"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.resource_group_name
  vss                 = var.vss
  nsg_ids             = module.nsg.nsg_ids
  subnet_ids          = module.vnet.subnet_ids #its new for testing
  lb-backend_ids      = [module.load_balancer.lb-backend_ids]
  user_data           = file("${path.module}/modules/vss/wordpress-userdata.sh")
}

module "nsg" {
  source              = "./modules/mysql-nsg"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.resource_group_name
  nsg_config          = var.nsg_config
}


module "vnet" {
  source              = "./modules/vnet"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.resource_group_name
  vnet_config         = var.vnet_config
  subnet_config       = var.subnet_config
}

module "load_balancer" {
  source              = "./modules/load_balancer"
  lb                  = var.lb_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.resource_group_name
}



module "nat_gateway" {
  source              = "./modules/nat-gateway"
  nat-var             = var.nat-var
  location            = module.resource_group.location
  resource_group_name = module.resource_group.resource_group_name
  subnet_id           = lookup(module.vnet.subnet_ids, "private-subnet", null) # Direct lookup for private subnet ID
}

module "mysql-server" {
  source              = "./modules/mysql-server"
  mysql               = var.mysql
  virtual_network_id  = module.vnet.vnet_ids
  subnet_ids          = module.vnet.subnet_ids
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.location
}