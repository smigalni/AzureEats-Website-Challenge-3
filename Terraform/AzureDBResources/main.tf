provider "azurerm" {
  version = "=2.0.0"
  features { }  
}

resource "azurerm_resource_group" "rg" {
  name     = var.resourceGroupName
  location = var.location
}

resource "azurerm_sql_server" "server" {
  name                         = var.sqlServerName
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.sqlServerUser
  administrator_login_password = var.sqlServerPassword

  tags = {
    environment = "chalenge 2"
  }
}

resource "azurerm_sql_database" "db" {
  name                = "mysqldatabase"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  server_name         = azurerm_sql_server.server.name  
}

resource "azurerm_container_group" "main" {
  name                  = "mongodbnamesergeynet"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  ip_address_type       = "public"
  dns_name_label        = "aci-label-sergey-net"
  os_type               = "Linux"

  container {
    name   = "mongodb"
    image  = "mongo:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 27017
      protocol = "TCP"
    }

    environment_variables = {
        MONGO_INITDB_ROOT_USERNAME = var.mongo_user
        MONGO_INITDB_ROOT_PASSWORD = var.mongo_password
    }
  }
}

resource "azurerm_app_service_plan" "app_plan" {
  name                = var.appServicePlanName
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "app_service" {
  name                = var.appServiceName
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.app_plan.id

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "10.15.2"
    "ApiUrl" = "/api/v1"	
    "ApiUrlShoppingCart" = "/api/v1"	
    "MongoConnectionString" = "mongodb://${var.mongo_user}:${var.mongo_password}@${azurerm_container_group.main.fqdn}:27017"	
    "SqlConnectionString" = "Server=tcp:${azurerm_sql_server.server.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_sql_database.db.name};Persist Security Info=False;User ID=${var.sqlServerUser};Password=${var.sqlServerPassword};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;" 	
    "productImagesUrl" =	"https://raw.githubusercontent.com/suuus/TailwindTraders-Backend/master/Deploy/tailwindtraders-images/product-detail"
    "Personalizer__ApiKey" = ""	
    "Personalizer__Endpoint" = ""
  }
}