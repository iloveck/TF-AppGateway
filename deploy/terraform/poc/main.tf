provider "azurerm" {
    version = "~> 2.0"
    features {}
}
# for poc
terraform {
 backend "azurerm" {
    resource_group_name   = "rg-terraform-poc"
    storage_account_name  = "mglotfcicd"
    container_name        = "terraform"
    key                   = "tf/mglo-web-ui/poc/terraform.tfstate"
    subscription_id = "e8944e02-1059-4620-abcd-cb9b316070b6"
    tenant_id = "8ce7d50c-b1e3-4530-a92f-86b2a446371b"
  }
}

module "resource_group" {
  source = "../modules/ResourceGroup"
  projectName = var.projectName
  componentName = var.componentName
  location = var.location
  environment = var.environment
}

module "application_insights" {
  source = "../modules/AppInsights"
  projectName = var.projectName
  componentName = var.componentName
  location = var.location
  environment = var.environment
  resourceGroupName = module.resource_group.name
}

module "application_gateway" {
  source = "../modules/AppGateway"
  VnetName = var.VnetName
  VnetRGName = var.VnetRGName
  SubnetName = var.SubnetName
  resourceGroupName = module.resource_group.name
  location = var.location
  AppGatewayWAFPolicy = var.AppGatewayWAFPolicy
  AppGatewayName  = var.AppGatewayName
  FrongEndIPAddr  = var.FrongEndIPAddr
  ssl_certificate_name  = var.ssl_certificate_name
  environment = var.environment
  appgw_fqdns = var.appgw_fqdns
}

