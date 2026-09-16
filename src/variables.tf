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

variable "https_traffic_only_enabled" {
  type        = bool
  description = "Whether the storage account accepts HTTPS traffic only."
  default     = true
}

variable "min_tls_version" {
  type        = string
  description = "Minimum TLS version permitted for storage account requests."
  default     = "TLS1_2"
}

variable "allow_nested_items_to_be_public" {
  type        = bool
  description = "Whether nested items may be configured for anonymous public access."
  default     = false
}

variable "shared_access_key_enabled" {
  type        = bool
  description = "Whether requests may be authorized with shared access keys."
  default     = true
}

variable "default_to_oauth_authentication" {
  type        = bool
  description = "Whether Azure portal data operations default to OAuth authentication."
  default     = false
}

variable "public_network_access" {
  type        = string
  description = "Public network endpoint state (Enabled or Disabled), or null to use the provider default."
  default     = null
  nullable    = true
}

variable "cross_tenant_replication_enabled" {
  type        = bool
  description = "Whether object replication may cross Microsoft Entra tenants."
  default     = false
}

variable "infrastructure_encryption_enabled" {
  type        = bool
  description = "Whether a second layer of platform-managed encryption is enabled."
  default     = false
}

variable "local_user_enabled" {
  type        = bool
  description = "Whether local users may access the storage account through SFTP or files."
  default     = false
}

variable "identity_type" {
  type        = string
  description = "Managed identity type, or null to omit a managed identity."
  default     = "SystemAssigned"
  nullable    = true
}

variable "network_rules" {
  type = object({
    default_action             = string
    bypass                     = set(string)
    ip_rules                   = set(string)
    virtual_network_subnet_ids = set(string)
  })
  description = "Public endpoint firewall rules, or null to retain Azure defaults."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Any tags that should be present on the resources."
  default     = {}
}
