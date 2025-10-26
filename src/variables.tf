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
  type    = string
  default = "Hot"
}
variable "account_kind" {
  type    = string
  default = "StorageV2"
}
variable "tags" {
  type        = map(string)
  description = "Any tags that should be present on the resources."
  default     = {}
}