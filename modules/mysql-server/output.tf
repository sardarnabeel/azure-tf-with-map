output "mysql_server_names" {
  description = "The names of the MySQL Flexible Servers"
  value       = { for k, v in azurerm_mysql_flexible_server.example : k => v.name }
}
output "mysql_server_fqdns" {
  description = "The fully qualified domain names (FQDNs) of the MySQL Flexible Servers"
  value       = { for k, v in azurerm_mysql_flexible_server.example : k => v.fqdn }
}

