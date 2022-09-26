


resource "azurerm_network_interface" "nic" {
  #for_each            = toset(var.vm_name)
  for_each            = toset(concat(var.app_vm, var.db_vm))
  name                = "${each.key}-nic"
  location            = var.location
  resource_group_name = lookup(local.resource_group, each.key)
  #tags = lookup(local.common_tags,each.key)

  ip_configuration {
    name                          = "internal"
    subnet_id                     = lookup(local.subnet-ids, each.key)
    private_ip_address_allocation = "Dynamic"
  }
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  #for_each            = toset(var.vm_name)
  for_each            = toset(concat(var.app_vm, var.db_vm))
  name                = each.value
  resource_group_name = lookup(local.resource_group, each.key)
  location            = var.location
  size                = lookup(local.vm-size, each.key)
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  #allow_extension_operations = (each.value == "sitweb" ? true : false)
  patch_mode               = "Manual"
  enable_automatic_updates = false

  #  tags = lookup(local.common_tags,each.key)
  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id,
  ]
  license_type = "Windows_Server"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    #   disk_encryption_set_id = "/subscriptions/7f60296c-ffff-46d1-b231-c71f26606fd8/resourceGroups/network-rg/providers/Microsoft.Compute/diskEncryptionSets/vm-encryption"
    #disk_encryption_set_id = data.azurerm_disk_encryption_set.disk-encrypt.id
  }

  # boot_diagnostics {
  #   storage_account_uri = "https://bootdiag54.blob.core.windows.net/"
  #   #storage_account_uri = data.azurerm_storage_account.diagstorage.primary_blob_endpoint
  # }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  #boot_diagnostics {
  #  enabled = "true" 
  #  storage_uri = data.azurem_storage_account.diagstorage.primary_blob_endpoint
  #}


  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

# resource "azurerm_managed_disk" "disk" {
#   for_each = toset(var.vm_name)
#   name     = "${each.value}-disk1"
#   # name                 = azurerm_windows_virtual_machine.vm[each.key].name  
#   location             = var.location
#   resource_group_name  = lookup(local.resource_group, each.key)
#   storage_account_type = "Standard_LRS"
#   create_option        = "Empty"
#   disk_size_gb         = lookup(local.data-disk-size, each.key)
#   #tags = local.common_tags
#   #tags = lookup(local.common_tags,each.key)
#   #  tags = lookup(local.common_tags,each.key)
#   # disk_encryption_set_id = data.azurerm_disk_encryption_set.disk-encrypt.id
#   depends_on = [
#     azurerm_windows_virtual_machine.vm
#   ]
#   lifecycle {
#     ignore_changes = [
#       # Ignore changes to tags, e.g. because a management agent
#       # updates these based on some ruleset managed elsewhere.
#       tags["owner"],
#     ]
#   }
# }

# resource "azurerm_virtual_machine_data_disk_attachment" "disk_attach" {
#   for_each           = toset(var.vm_name)
#   managed_disk_id    = azurerm_managed_disk.disk[each.key].id
#   virtual_machine_id = azurerm_windows_virtual_machine.vm[each.key].id
#   lun                = "10"
#   caching            = "ReadWrite"
#   depends_on = [
#     azurerm_managed_disk.disk
#   ]

# }


# output "appvm_private_ip_address_map" {
#   description = "App  Virtual Machine Private IP"
#   value       = { for vm in azurerm_windows_virtual_machine.vm : vm.name => vm.private_ip_address }
# }



