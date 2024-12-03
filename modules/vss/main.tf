resource "azurerm_linux_virtual_machine_scale_set" "example" {
  for_each            = var.vss
  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard_F2"
  instances           = 1
  admin_username      = "adminuser"


  admin_ssh_key {
    username   = "adminuser"
    public_key = file(each.value.public_key)
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
  # custom_data = base64encode(file("${path.module}/wordpress-userdata.sh"))
  custom_data = base64encode(var.user_data)


  network_interface {
    name    = "example-nic"
    primary = true
    network_security_group_id = var.nsg_ids[each.value.nsg_name]

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = var.subnet_ids[each.value.subnet_name]
      load_balancer_backend_address_pool_ids = var.lb-backend_ids
  
    }
  }
}