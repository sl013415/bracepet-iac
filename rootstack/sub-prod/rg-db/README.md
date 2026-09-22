# sub-prod / rg-db

This root stack creates the `rg-db` resource group and Azure Database for PostgreSQL Flexible Server.

## Apply

```bash
terraform init -backend-config=backend.hcl
terraform fmt -recursive
terraform validate
terraform plan
terraform apply -var="postgres_admin_password=<strong-password>"
```

Use a strong password and prefer Azure Key Vault or environment-based secret injection in CI/CD instead of hardcoding values.
