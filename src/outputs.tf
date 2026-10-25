output "id" {
  description = "The ID of the storage account."
  value       = azurerm_storage_account.this.id
}

output "name" {
  description = "The name of the storage account."
  value       = azurerm_storage_account.this.name
}

output "location" {
  description = "The location of the storage account."
  value       = azurerm_storage_account.this.location
}

output "primary_access_key" {
  description = "The primary access key for the storage account."
  value       = azurerm_storage_account.this.primary_access_key
  sensitive   = true
}

output "primary_connection_string" {
  description = "The primary connection string for the storage account."
  value       = azurerm_storage_account.this.primary_connection_string
  sensitive   = true
}

output "container_ids" {
  description = "ARM resource IDs of private Blob containers keyed by name."
  value       = { for name, container in azurerm_storage_container.this : name => container.id }
}

output "container_urls" {
  description = "Credential-free Blob container URLs keyed by name."
  value       = { for name, container in azurerm_storage_container.this : name => container.url }
}

output "queue_ids" {
  description = "ARM resource IDs of Storage Queues keyed by name."
  value       = { for name, queue in azurerm_storage_queue.this : name => queue.id }
}

output "queue_urls" {
  description = "Credential-free Storage Queue URLs keyed by name."
  value       = { for name, queue in azurerm_storage_queue.this : name => queue.url }
}

output "table_ids" {
  description = "ARM resource IDs of Storage Tables keyed by name."
  value       = { for name, table in azurerm_storage_table.this : name => table.id }
}
