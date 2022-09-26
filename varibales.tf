# variable "vm_name" {
#   type    = list(string)
#   default = concat(var.app_vm,var.db_vm)
# }

variable "app_vm" {
  type = list(any)
}

variable "db_vm" {
  type = list(any)
}

variable "sql_disk_name" {
  type = list(any)
}

variable "sql_disk_size" {
  type = list(number)
}


variable "location" {
  type    = string
  default = "centeral-india"
}

variable "web_vm_size" {
  type = string
}

variable "db_vm_size" {
  type = string
}


variable "web_data_disk_size" {
  type = string
}

variable "db_data_disk_size" {
  type = string
}

# variable "environment" {
#     type = string
#     default = "prod" 
# }

# variable "cloud" {
#     type = string
#     default = "azure"

#}

variable "web_rg" {
  type    = string
  default = "web-rg"
}

variable "db_rg" {
  type    = string
  default = "db-rg"
}

variable "vnet" {
  type    = string
  default = "test-vnet"
}

variable "dbsubnet" {
  type    = string
  default = "dbsubnet"
}

variable "websubnet" {
  type    = string
  default = "websubnet"
}
