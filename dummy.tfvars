#subscription_id = "TBD"
#tenant_id       = "TBD"
location = "westeurope"

storage_account_name = "my-storage-account"
storage_account_replication_type = "GRS"
storage_account_tier = "Standard"

service_principal_name                = "storage-account-contributor"
service_principal_rotate_when_changed = {
  expiration = "2099-12-31" # just change this when you want to rotate service principal password
}

circleci_organization = "my-cool-organization"
circleci_repository   = "my-cool-repo"
