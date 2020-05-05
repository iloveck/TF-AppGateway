resource "random_string" "storage_name" {
    length = 24
    upper = false
    lower = true
    number = true
    special = false
}

#----- Virtual Network information ------
data "azurerm_virtual_network" "this" {
  name     = var.VnetName
  resource_group_name  = var.VnetRGName
}

#------Query existing subnet
 data "azurerm_subnet" "this" {
  name                 = var.SubnetName
  resource_group_name  = data.azurerm_virtual_network.this.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.this.name
}

 data "azurerm_subnet" "devtestlab" {
  name                 = "snet-devtestlab"
  resource_group_name  = data.azurerm_virtual_network.this.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.this.name
}
 data "azurerm_subnet" "appgateway" {
  name                 = "snet-applicationgateway"
  resource_group_name  = data.azurerm_virtual_network.this.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.this.name
}
#---------------------------Azure function------

#------Storage Account--------
resource "azurerm_storage_account" "this" {
  name                     = random_string.storage_name.result
  resource_group_name      = var.resourceGroupName
# The location should be gathered from a "map" of paired regions. This would allow IP
# whitelisting. if the Function and storage account are in the same region microsoft
# doesn't respect ip whitelists.
  location                 = var.pairedRegionMap[var.location]
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = {
    #ip_restriction tag will allow a different service to apply network restrictions 
    #allowing only the specified IPs.
    ip_restriction        = "AppService.${var.location}"
    environment = var.environment
  }
}

#------App Service Plan---------
data "azurerm_app_service_plan" "this" {
  name                = var.FunctionAppPlanName
  resource_group_name = var.FunctionAppPlanRGName
}

#------Function App--------------
resource "azurerm_function_app" "this" {
  name                      = var.FunctionName
  location                  = var.location
  resource_group_name       = var.resourceGroupName
  app_service_plan_id       = data.azurerm_app_service_plan.this.id
  storage_connection_string = azurerm_storage_account.this.primary_connection_string
  https_only = "true"
  version = "~3"
  app_settings = merge(var.app_settings,{APPINSIGHTS_INSTRUMENTATIONKEY = var.appInsightsKey})
  tags = {
    environment = var.environment
  }
  site_config {
    ftps_state = "FtpsOnly"
    http2_enabled = "true"
    cors {
      allowed_origins = ["https://10.211.17.69",
						"http://localhost:4200"]    
    }
    ip_restriction {
      subnet_id = data.azurerm_subnet.devtestlab.id
    }
    ip_restriction {
      subnet_id = data.azurerm_subnet.appgateway.id
    }
    ip_restriction {
      subnet_id = data.azurerm_subnet.devtestlab.id
    }
    ip_restriction {
      subnet_id = data.azurerm_subnet.appgateway.id
    }
    dynamic "ip_restriction" {
      for_each = var.allowed_ip_addresses
      content {
        ip_address  = ip_restriction.value
      }
    } 
  } 
}

//TODO If this is applied, the deployment fails. Need to create a better whitelist. 
/*
resource "azurerm_template_deployment" "app-service-scm-ipwhitelist" {
  name                = "${azurerm_function_app.this.name}-scm-ipwhitelist"
  resource_group_name = azurerm_resource_group.this.name
  template_body       = file("../modules/functions/arm/app-service-scm-ipwhitelist.json")
  parameters = {
    FunctionName = azurerm_function_app.this.name
  }
  deployment_mode     = "Incremental"
} */
