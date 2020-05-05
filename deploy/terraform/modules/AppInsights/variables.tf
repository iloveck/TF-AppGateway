variable "location" {
    type = string
    default = "westus2"
}

variable "resourceGroupName" {
    type = string
}

variable "projectName" {
    type = string
    default = "mglo"
}

variable "componentName" {
    type = string
}

variable "environment" {
    type = string
    default = "dev"
}
variable "appType" {
    type = string
    default = "web"
}

variable "compPrefix" {
    type = string
    default = "ai"
}