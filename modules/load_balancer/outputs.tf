# output "lb_public_ip" {
#   value = azurerm_public_ip.lb_public_ip.ip_address
# }
output "lb-backend_ids" {
  value = azurerm_lb_backend_address_pool.example.id
}