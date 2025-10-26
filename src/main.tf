#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
resource "azurerm_storage_account" "this" {
  name                            = var.storage_account_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_kind                    = var.account_kind #default is StorageV2
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  access_tier                     = var.access_tier #default is Hot
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_2"
  tags                            = var.tags
  identity {
    type = "SystemAssigned"
  }
}
