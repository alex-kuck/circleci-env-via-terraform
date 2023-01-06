terraform {
  required_providers {
    azurerm = ">=3.11.0"
    azuread = ">=2.19.1"

    circleci = {
      source  = "mrolla/circleci" # c.f. https://registry.terraform.io/providers/mrolla/circleci/latest/docs
      version = ">=0.6.1"
    }
  }

  required_version = ">= 1.2.5, < 3.0.0"
}

provider "azurerm" {
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  features {}
}
provider "azuread" {
  tenant_id = var.tenant_id
}
provider "circleci" {
  vcs_type     = "github"
  organization = var.circleci_organization
}

### Storage Account ###
resource "azurerm_resource_group" "example" {
  name     = "awesome-resource-group"
  location = var.location
}
resource "azurerm_storage_account" "example" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.example.name
  location                 = var.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
}

### Service Principal ###
# Create Azure AD App
resource "azuread_application" "example" {
  display_name            = var.service_principal_name
  owners                  = [] # Object IDs of AzureAD users
  prevent_duplicate_names = true
}
# Create Service Principal associated with the Azure AD App
resource "azuread_service_principal" "example" {
  application_id = azuread_application.example.application_id

  lifecycle {
    ignore_changes = [
      owners
    ]
  }
}
# Create role assignments for service principal
locals {
  service_principal_role_assignments = [
    {
      role_name = "Storage Blob Data Contributor"
      scope     = azurerm_storage_account.example.id
    }
  ]
}
resource "azurerm_role_assignment" "example" {
  count = length(local.service_principal_role_assignments)

  principal_id         = azuread_service_principal.example.id
  role_definition_name = local.service_principal_role_assignments[count.index].role_name
  scope                = local.service_principal_role_assignments[count.index].scope
}
# Create password for service principal
resource "azuread_service_principal_password" "example" {
  service_principal_id = azuread_service_principal.example.object_id

  rotate_when_changed = var.service_principal_rotate_when_changed # any changes in this variable will cause a rotation of the password
}

### Circle CI ###
# Create a CircleCI Context
resource "circleci_context" "example" {
  name = "my-terraform-variables"
}
# Populate context with ENV variables
resource "circleci_context_environment_variable" "container_registry" {
  for_each = {
    AZURE_SP          = azuread_service_principal.example.application_id
    AZURE_SP_PASSWORD = azuread_service_principal_password.example.value
  }

  variable   = each.key
  value      = each.value
  context_id = circleci_context.example.id
}

# OR set project-specific ENV variable instead
resource "circleci_environment_variable" "token" {
  for_each = {
    AZURE_SP          = azuread_service_principal.example.application_id
    AZURE_SP_PASSWORD = azuread_service_principal_password.example.value
  }

  name         = each.key
  value        = each.value
  project      = var.circleci_repository
  organization = var.circleci_organization
}
