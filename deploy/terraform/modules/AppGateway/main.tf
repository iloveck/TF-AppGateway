
/*=====================================+=======================================*
*                                                                              *
*                            Query existing data recources                     *
*                                                                              *
*==============================================================================*/
#--------  Vnet    -------
data "azurerm_virtual_network" "this" {
  name                  = var.VnetName
  resource_group_name   = var.VnetRGName
}
#-------- Subnet   -------
/*data "azurerm_subnet" "this" {
  name                 = var.SubnetName
  resource_group_name  = data.azurerm_virtual_network.this.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.this.name
}*/
 # appgateway subnet
 data "azurerm_subnet" "web-appgateway" {
  name                 = var.SubnetName
  resource_group_name  = data.azurerm_virtual_network.this.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.this.name
}
/*=====================================+=======================================*
*                                                                              *
*                            Provisioning New Recources                        *
*                                                                              *
*==============================================================================*/
# local variables for repeat use
locals {
  backend_address_pool_name      = "${var.AppGatewayName}-BE-Pool"
  frontend_port_name             = "${var.AppGatewayName}-FE-port443"
  frontend_ip_configuration_name = "${var.AppGatewayName}-frontend-ip"
  http_setting_name              = "${var.AppGatewayName}-http-setting"
  listener_name                  = "${var.AppGatewayName}-http-listener01"
  request_routing_rule_name      = "${var.AppGatewayName}-https-rule"
  redirect_configuration_name    = "${var.AppGatewayName}-redirect-config"
  backend_health_probe_name      = "${var.AppGatewayName}-prob"
}
/*==============================================================================*
*   Application Gateway & WAF                                                   *
*===============================================================================*/
#------  waf policy    -------
/*resource "azurerm_web_application_firewall_policy" "this" {
  name                = var.AppGatewayWAFPolicy
  resource_group_name = var.resourceGroupName
  location            = var.location
}*/
#------  application gateway ------
resource "azurerm_application_gateway" "this" {
  name                = "${var.AppGatewayName}-${var.environment}"
  resource_group_name = var.resourceGroupName
  location            = var.location
  tags = {
    environment = var.environment
  }
  sku {
    name     = "WAF_Medium"
    tier     = "WAF"
    capacity = 1
  }
  # gateway ip config
  gateway_ip_configuration {
    name      = "mglo-gateway-ip-configuration"
    subnet_id = data.azurerm_subnet.web-appgateway.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 443
  }

  frontend_ip_configuration {
    name               = local.frontend_ip_configuration_name
    subnet_id = data.azurerm_subnet.web-appgateway.id
    private_ip_address = var.FrongEndIPAddr
  }
  backend_address_pool {
    name  = local.backend_address_pool_name
    #ip_address_list = ["x.x.x.x"]
    #fqdns = var.appgw_fqdns
    #fqdns = ["webservertestpoc.azurewebsites.net"]
  }
 # backend_health_probe {
  probe {
    name                  = local.backend_health_probe_name
    protocol              = "HTTPS"
    path                  = "/"
    interval              = "30"
    timeout               = "30"
    unhealthy_threshold   = "3"
    pick_host_name_from_backend_http_settings = "true"
    # match = ?
    # ?? Use probe matching conditions
  }
  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 443
    protocol              = "HTTPS"
    request_timeout       = 5
    probe_name            = local.backend_health_probe_name
    pick_host_name_from_backend_address = "true"
  }
  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Https"
    ssl_certificate_name           = var.ssl_certificate_name
    # ? waf-policy                     = azurerm_web_application_firewall_policy.this.name
  }
  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }

  ssl_certificate {
    name      =  var.ssl_certificate_name
    # data      =  “${base64encode(file(“MGLO-AppGateway.pfx”))}”
    data      = filebase64("MGLO-AppGateway.pfx")
    password  =  "Nantong651230!"
  }

# waf_configuration {
#   enabled = "true"
#   name        = azurerm_web_application_firewall_policy.this.name
# }

}
