data "azurerm_resource_group" "rg-web" {
  name = var.web_rg
}

data "azurerm_resource_group" "rg-cb" {
  name = var.db_rg
}

data "azurerm_resource_group" "rg-nw" {
  name = "test-rg"
}

data "azurerm_virtual_network" "vnet" {
  name                = var.vnet
  resource_group_name = data.azurerm_resource_group.rg-nw.name
}

data "azurerm_subnet" "dbsubnet" {
  name                 = var.dbsubnet
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg-nw.name
}

data "azurerm_subnet" "websubnet" {
  name                 = var.websubnet
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg-nw.name
}

#data "azurerm_disk_encryption_set" "disk-encrypt" {
#     name  = "vm-encryption"
#     resource_group_name = data.azurerm_resource_group.rg-nw.name
#}

# data "azurerm_storage_account" "diagstorage"  {
#      name =  "bootdiag54"
#     resource_group_name = data.azurerm_resource_group.rg-nw.name
# }