# locals {
#   # Common tags to be assigned to all resources
#   common_tags = {
#     env = "${var.environment}"
#     cloud  = "${var.cloud}"
#   }
# }

# locals {
#   common_tags = {
#     prodweb = {
#       # size = "Standard_B2s"
#       # data-disk-size = 10
#       # subnet-id = data.azurerm_subnet.websubnet.id

#       app = "web"
#       application = "payment collection"

#     }
#     prodapp = {
#       # size = "Standard_B2ms"
#       # data-disk-size = 50
#       # subnet-id = data.azurerm_subnet.appsubnet.id 

#       app = "app"
#       application = "batchgate"

#     }
#     sitweb = {
#       # size = "Standard_B2s"
#       # data-disk-size = 10
#       # subnet-id = data.azurerm_subnet.websubnet.id
#        app = "web"
#       application = "infeligate UAE"
#     }

# }
# }


locals {
  subnet-ids = {
    sitweb = data.azurerm_subnet.websubnet.id
    sitdb1 = data.azurerm_subnet.dbsubnet.id
    sitdb2 = data.azurerm_subnet.dbsubnet.id
  }
}

locals {
  vm-size = {
    sitweb = var.web_vm_size
    sitdb1 = var.db_vm_size
    sitdb2 = var.db_vm_size
  }
}

locals {
  data-disk-size = {
    sitweb = var.web_data_disk_size
    sitdb1 = var.db_data_disk_size
    sitdb2 = var.db_data_disk_size
  }
}

locals {
  resource_group = {
    sitweb = var.web_rg
    sitdb1 = var.db_rg
    sitdb2 = var.db_rg
  }
}

locals {
  install_iis = {
    sitweb = true
    sitdb  = false
  }
}