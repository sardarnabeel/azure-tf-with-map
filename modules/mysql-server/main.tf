#Private DNS Zone for MySQL
resource "azurerm_private_dns_zone" "example" {
  name                = "privatelink.mysql.database.azure.com"   # The DNS zone for MySQL
  resource_group_name = var.resource_group_name
}

# Link the Virtual Network to the Private DNS Zone
resource "azurerm_private_dns_zone_virtual_network_link" "example" {
  for_each              = var.mysql
  name                  = "exampleVnetZone.com"
  # name                  = "${each.key}-vnet-link"
  private_dns_zone_name = azurerm_private_dns_zone.example.name
  virtual_network_id    = var.virtual_network_id[each.value.vnet_name]
  resource_group_name   = var.resource_group_name

  # registration_enabled = true
}

# MySQL Flexible Server
resource "azurerm_mysql_flexible_server" "example" {
  for_each = var.mysql
  name                   = "nabeel-fs"
  # name                   = "${each.key}-fs"
  resource_group_name    = var.resource_group_name
  location               = var.location
  administrator_login    = "psqladmin"
  administrator_password = "H@Sh1CoR3!"
  backup_retention_days  = 7
  # delegated_subnet_id    = var.subnet_ids[each.value.subnet_name]
  delegated_subnet_id    = null
  private_dns_zone_id    = azurerm_private_dns_zone.example.id
  sku_name               = "GP_Standard_D2ds_v4"

  depends_on = [azurerm_private_dns_zone_virtual_network_link.example]
}

# MySQL Database
resource "azurerm_mysql_flexible_database" "example" {
  for_each           = var.mysql
  name               = each.value.database_name
  resource_group_name = azurerm_mysql_flexible_server.example[each.key].resource_group_name
  server_name         = azurerm_mysql_flexible_server.example[each.key].name
  collation           = "utf8mb4_general_ci"
  charset             = "utf8mb4"
}

# Private Endpoint for MySQL
resource "azurerm_private_endpoint" "example" {
  for_each            = var.mysql
  name                = "${each.key}-private-endpoint"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_ids[each.value.subnet_name]

  private_service_connection {
    name                           = "${each.key}-mysql-connection"
    private_connection_resource_id = azurerm_mysql_flexible_server.example[each.key].id
    is_manual_connection           = false
    subresource_names              = ["mysqlServer"]
  }

  # Attach Private DNS Zone
  private_dns_zone_group {
    name                 = "mysql-private-dns-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.example.id]
  }
  # tags = var.tags
}

# DNS A record to route traffic to the Private Endpoint (FQDN resolution)
resource "azurerm_private_dns_a_record" "example" {
  for_each            = var.mysql
  name                = azurerm_mysql_flexible_server.example[each.key].fqdn
  # name                = "nabeel-fs"
  zone_name           = azurerm_private_dns_zone.example.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.example[each.key].private_service_connection[0].private_ip_address]

  depends_on = [azurerm_private_endpoint.example]
}

