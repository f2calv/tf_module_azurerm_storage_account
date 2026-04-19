variable "resource_group_name" {
  type        = string
  description = "Name of the parent resource group."
}

variable "location" {
  type        = string
  description = "Location of the parent resource group."
  default     = "West Europe"
}

variable "storage_account_name" {
  type        = string
  description = "Name of the storage account."
}

variable "access_tier" {
  type        = string
  description = "Storage account access tier (Hot or Cool)."
  default     = "Hot"
}

variable "account_kind" {
  type        = string
  description = "Storage account kind (StorageV2, BlobStorage, etc.)."
  default     = "StorageV2"
}

variable "account_tier" {
  type        = string
  description = "Storage account tier (Standard or Premium)."
  default     = "Standard"
}

variable "account_replication_type" {
  type        = string
  description = "Storage account replication type (LRS, GRS, RAGRS, ZRS)."
  default     = "LRS"
}

variable "tags" {
  type        = map(string)
  description = "Any tags that should be present on the resources."
  default     = {}
}
