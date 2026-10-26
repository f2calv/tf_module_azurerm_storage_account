# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
resource "azurerm_storage_account" "this" {
  name                              = var.storage_account_name
  resource_group_name               = var.resource_group_name
  location                          = var.location
  account_kind                      = var.account_kind
  account_tier                      = var.account_tier
  account_replication_type          = var.account_replication_type
  access_tier                       = var.access_tier
  https_traffic_only_enabled        = var.https_traffic_only_enabled
  min_tls_version                   = var.min_tls_version
  allow_nested_items_to_be_public   = var.allow_nested_items_to_be_public
  shared_access_key_enabled         = var.shared_access_key_enabled
  default_to_oauth_authentication   = var.default_to_oauth_authentication
  public_network_access             = var.public_network_access
  cross_tenant_replication_enabled  = var.cross_tenant_replication_enabled
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled
  local_user_enabled                = var.local_user_enabled
  tags                              = var.tags

  lifecycle {
    precondition {
      condition     = length(var.containers) == 0 || contains(["Storage", "StorageV2", "BlobStorage", "BlockBlobStorage"], var.account_kind)
      error_message = "Containers require a Blob-capable storage account kind."
    }

    precondition {
      condition     = (length(var.queues) == 0 && length(var.tables) == 0) || (contains(["Storage", "StorageV2"], var.account_kind) && var.account_tier == "Standard")
      error_message = "Queues and tables require a Standard Storage or StorageV2 account."
    }
  }

  dynamic "network_rules" {
    for_each = var.network_rules == null ? [] : [var.network_rules]

    content {
      default_action             = network_rules.value.default_action
      bypass                     = network_rules.value.bypass
      ip_rules                   = network_rules.value.ip_rules
      virtual_network_subnet_ids = network_rules.value.virtual_network_subnet_ids
    }
  }

  dynamic "identity" {
    for_each = var.identity_type == null ? [] : [var.identity_type]

    content {
      type = identity.value
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container
resource "azurerm_storage_container" "this" {
  for_each = var.containers

  name                  = each.key
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_queue
resource "azurerm_storage_queue" "this" {
  for_each = var.queues

  name               = each.key
  storage_account_id = azurerm_storage_account.this.id
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_table
resource "azurerm_storage_table" "this" {
  for_each = var.tables

  name               = each.key
  storage_account_id = azurerm_storage_account.this.id
}
