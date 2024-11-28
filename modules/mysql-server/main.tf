resource "azurerm_private_dns_zone" "example" {
  name                = "example.mysql.database.azure.com"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "example" {
  for_each              = var.mysql
  name                  = "exampleVnetZone.com"
  private_dns_zone_name = azurerm_private_dns_zone.example.name
  virtual_network_id    = var.virtual_network_id[each.value.vnet_name]
  resource_group_name   = var.resource_group_name
}

resource "azurerm_mysql_flexible_server" "example" {
  for_each = var.mysql
  name                   = "${each.value.name}-nabeel-fs"
  resource_group_name    = var.resource_group_name
  location               = var.location
  administrator_login    = "psqladmin"
  administrator_password = "H@Sh1CoR3!"
  backup_retention_days  = 7
  delegated_subnet_id    = var.subnet_ids[each.value.subnet_name]
  private_dns_zone_id    = azurerm_private_dns_zone.example.id
  sku_name               = "GP_Standard_D2ds_v4"

  depends_on = [azurerm_private_dns_zone_virtual_network_link.example]
}
resource "azurerm_mysql_flexible_database" "example" {
  for_each           = var.mysql
  name               = each.value.database_name  # This is the database name
  resource_group_name = azurerm_mysql_flexible_server.example[each.key].resource_group_name
  server_name         = azurerm_mysql_flexible_server.example[each.key].name
  collation           = "utf8mb4_general_ci"     # Optional, specify the collation
  charset             = "utf8mb4"               # Optional, specify the charset
}