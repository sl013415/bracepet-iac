# Bootstrap

This stack creates the Azure Storage Account used for Terraform remote state.

Run it once from this directory with a locally protected state:

```bash
az login
terraform init
terraform fmt -check
terraform validate
terraform plan
terraform apply
```

After the storage account exists, each root stack uses its own `backend.hcl` and state key.
