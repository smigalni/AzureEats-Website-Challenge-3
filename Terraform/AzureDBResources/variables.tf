variable "appServiceName" {
  description = "The name of app service"
}

variable "appServicePlanName" {
  description = "The name of app service plan"
}

variable "sqlServerUser" {
  description = "The administrator login user"
}

variable "sqlServerPassword" {
  description = "The administrator login password"
}

variable "sqlServerName" {
  description = "The sql server name"
}

variable "resourceGroupName" {
  description = "The name of resource group"
}

variable "mongo_user" {
  description = "The administrator login user"
}

variable "mongo_password" {
  description = "The administrator login user password"
}

variable "location" {
  description = "Location"
}

variable "subscriptionId" {
  description = "Subscription id"
}

variable "tenantId" {
  description = "Tenant id"
}

variable "clientId" {
  description = "Client id"
}

variable "clientSecret" {
  description = "Client secret"
}