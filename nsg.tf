
resource "azurerm_network_security_group" "app_vmnic_nsg" {
  #for_each = toset(var.vm_name)
  for_each = toset(concat(var.app_vm, var.db_vm))
  name     = "${each.key}-nsg"
  #name                = "app-nsg"
  location            = var.location
  resource_group_name = lookup(local.resource_group, each.key)
  #tags = local.common_tags
  #tags = lookup(local.common_tags,each.key)
  # tags = lookup(local.common_tags,each.key)
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }

  security_rule {
    name                       = "http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # security_rule {
  #   name                       = "https"
  #   priority                   = 110
  #   direction                  = "Inbound"
  #   access                     = "Allow"
  #   protocol                   = "Tcp"
  #   source_port_range          = "*"
  #   destination_port_range     = "443"
  #   source_address_prefix      = "*"
  #   destination_address_prefix = "*"
  # }

  security_rule {
    name                       = "rdp"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Resource-2: Associate NSG and Linux VM NIC
resource "azurerm_network_interface_security_group_association" "app_vmnic_nsg_associate" {
  # depends_on = [ azurerm_network_security_rule.app_vmnic_nsg_rule_inbound]
  #for_each                  = toset(var.vm_name)
  for_each                  = toset(concat(var.app_vm, var.db_vm))
  network_interface_id      = azurerm_network_interface.nic[each.key].id
  network_security_group_id = azurerm_network_security_group.app_vmnic_nsg[each.key].id
}

/* /* # Resource-3: Create NSG Rules
## Locals Block for Security Rules
locals {
  web_vmnic_inbound_ports_map = {
    "100" : "80", # If the key starts with a number, you must use the colon syntax ":" instead of "="
    "110" : "443",
    "120" : "3389"
  }  */

/* ## NSG Inbound Rule for WebTier Subnets
resource "azurerm_network_security_rule" "app_vmnic_nsg_rule_inbound" {
  for_each = local.web_vmnic_inbound_ports_map
  name                        = "Rule-Port-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value 
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.rg-nw.name
  network_security_group_name = azurerm_network_security_group.app_vmnic_nsg[each.key].name
} */
