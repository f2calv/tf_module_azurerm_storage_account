# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
resource "azurerm_storage_account" "this" {
  name                            = var.storage_account_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_kind                    = var.account_kind
  account_tier                    = var.account_tier
  account_replication_type        = var.account_replication_type
  access_tier                     = var.access_tier
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_2"
  tags                            = var.tags

  identity {
    type = "SystemAssigned"
  }
}
