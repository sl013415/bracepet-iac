# sub-prod / rg-paas

This root stack creates the `rg-paas` resource group with the Azure Static Web App, Azure Container Registry, AKS, and monitoring workspace.

## Apply

```bash
terraform init -backend-config=backend.hcl
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

Run the networking stack first so the AKS subnet remote state is available.
