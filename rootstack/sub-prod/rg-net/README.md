# sub-prod / rg-net

This root stack creates the `rg-net` resource group and its shared networking resources.

## Apply

```bash
terraform init -backend-config=backend.hcl
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

Run `bootstrap/` first so the remote state storage exists.
