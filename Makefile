fmt: ## format terraform files
	terraform fmt -recursive
dummy-plan: ## make a plan of resource updates
	terraform plan --var-file=dummy.tfvars --out dummy.tfplan
dummy-apply: ## execute previously created plan
	terraform apply dummy.tfplan
dummy-destroy: ## delete all resources
	terraform destroy --var-file=dummy.tfvars