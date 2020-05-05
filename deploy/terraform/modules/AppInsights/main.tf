resource "azurerm_application_insights" "this" {
  name                = "${var.compPrefix}-${var.projectName}-${var.componentName}-${var.environment}"
  location            = var.location
  resource_group_name = var.resourceGroupName
  application_type    = var.appType
  tags = {
    environment = var.environment
  }
}

