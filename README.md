# Terraform Module: Azure Storage Account

Provisions an [Azure Storage Account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) with sensible defaults — TLS 1.2 enforced, public blob access disabled, SystemAssigned managed identity enabled.

## Usage

```hcl
module "storage" {
  source               = "git::https://github.com/f2calv/tf_module_azurerm_storage_account.git//src?ref=main"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  storage_account_name = "mystorageaccount"
  tags                 = { environment = "dev" }
}
```

## Variables

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `resource_group_name` | `string` | — | Name of the parent resource group |
| `location` | `string` | `West Europe` | Location of the parent resource group |
| `storage_account_name` | `string` | — | Name of the storage account |
| `access_tier` | `string` | `Hot` | Storage account access tier (Hot or Cool) |
| `account_kind` | `string` | `StorageV2` | Storage account kind (StorageV2, BlobStorage, etc.) |
| `account_tier` | `string` | `Standard` | Storage account tier (Standard or Premium) |
| `account_replication_type` | `string` | `LRS` | Storage account replication type (LRS, GRS, RAGRS, ZRS) |
| `tags` | `map(string)` | `{}` | Any tags that should be present on the resources |

## Outputs

| Name | Sensitive | Description |
| --- | --- | --- |
| `id` | No | The ID of the storage account |
| `name` | No | The name of the storage account |
| `location` | No | The location of the storage account |
| `primary_access_key` | Yes | The primary access key for the storage account |
| `primary_connection_string` | Yes | The primary connection string for the storage account |
