### General Azure Information ###
variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}
variable "tenant_id" {
  type        = string
  description = "Azure tenant ID"
}
variable "location" {
  type        = string
  description = "Location for resources"
}

### Storage Account ###
variable "storage_account_name" {
  type        = string
  description = "Name for storage account"
}
variable "storage_account_tier" {
  type        = string
  description = "Storage account tier"
}
variable "storage_account_replication_type" {
  type        = string
  description = "Replication type for storage account"
}

### Service Principal ###
variable "service_principal_name" {
  type = string
}
variable "service_principal_rotate_when_changed" {
  type        = map(any)
  description = "Any change to this variable will cause the service principal password to be rotated"
  default     = null
}

### CircleCI ###
variable "circleci_organization" {
  type        = string
  description = "Name of your organization in VCS"
  default     = null
}
variable "circleci_repository" {
  type        = string
  description = "Name of your repository in VCS"
}