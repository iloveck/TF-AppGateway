/*
output "function_name" {
  value = module.premium_function.function_name
}

output "rg_name" {
  value = module.resource_group.name
}

output "subnet_address_prefix" {
  value = module.premium_function.subnet_address_prefix
  description = "Location of peered VNET"
}

output "subnet_name" {
  value = module.premium_function.subnet_name
  description = "Location of peered VNET"
}

output "vnet_id" {
  value = module.premium_function.vnet_id
  description = "Location of peered VNET"
}

output "vnet_name" {
  value = module.premium_function.vnet_name
  description = "VNET for functions backend integration"
}
*/
output "appgateway_name" {
  value = module.application_gateway.appgateway_name
  description = "appliction Gateway for Web App"
}
