resource "azurerm_virtual_machine_extension" "vm_extension_install_iis" {
  for_each = toset(var.app_vm)
  #for_each  = [toset(var.vm_name) == "sitweb" ? 1 : 0]
  #for_each = {for k,v in var.vm_name : k => v if v.allow_extension_operations == true}
  #for_each = toset([for k in var.vm_name : k if lookup(local.install_iis, k) == true])
  #for_each = toset(var.vm_name)
  #count = (azurerm_windows_virtual_machine.vm[each.key].name == "sitweb" ? 0 : 1)
  name                       = "${azurerm_windows_virtual_machine.vm[each.key].name}-vm_extension_install_iis"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm[each.key].id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.10"
  auto_upgrade_minor_version = true
  depends_on = [
    azurerm_windows_virtual_machine.vm
  ]

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools"
    }
SETTINGS
}

# ############

locals {
  sql_disks = zipmap(var.sql_disk_name, var.sql_disk_size)
  disk_map = flatten([
    for vm in var.db_vm : [
      for disk, size in local.sql_disks : [
        { vm   = vm
          disk = "${vm}-${disk}"
          size = size
        }

      ]
    ]
  ])
  my-map = { for key, value in local.disk_map : key => value }
}

# locals {
#   my-map = { for key, value in local.disk_map : key => value }
# }


resource "azurerm_managed_disk" "sql_disk" {
  for_each             = local.my-map
  name                 = each.value.disk
  location             = var.location
  resource_group_name  = lookup(local.resource_group, each.value.vm)
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = each.value.size

  depends_on = [
    azurerm_windows_virtual_machine.vm
  ]
  lifecycle {
    ignore_changes = [
     
    ]
  }
}



resource "azurerm_virtual_machine_data_disk_attachment" "disk_attach" {
  for_each           = local.my-map
  managed_disk_id    = azurerm_managed_disk.sql_disk[each.key].id
  virtual_machine_id = azurerm_windows_virtual_machine.vm[each.value.vm].id
  lun                = each.key + 10
  caching            = "ReadWrite"
  depends_on = [
    azurerm_managed_disk.sql_disk
  ]

}









# resource "azurerm_virtual_machine_data_disk_attachment" "disk_attach" {
#   count = length(var.sql_disk_name)
#   managed_disk_id    = element(azurerm_managed_disk.sql_disk.*.id,count.index)
#   virtual_machine_id = element(azurerm_windows_virtual_machine.vm.*.sitdb.id,count.index)
#   lun                = 10 + count.index
#   caching            = "ReadWrite"
#   depends_on = [
#     azurerm_managed_disk.sql_disk
#   ]

# }

