# BreacePet Azure Infrastructure

This repository contains the Azure Terraform infrastructure for the BreacePet application.

## Architecture

- `rg-net` contains networking resources and private DNS zones.
- `rg-paas` contains AKS, ACR, Static Web App, and monitoring resources.
- `rg-db` contains PostgreSQL Flexible Server resources.
- Each stack is deployed independently with its own remote state file.

## Deployment order

1. `bootstrap/`
2. `rootstack/sub-prod/rg-net`
3. `rootstack/sub-prod/rg-paas`
4. `rootstack/sub-prod/rg-db`

## Azure authentication

Use Azure CLI locally or OIDC/managed identity in CI/CD.

Do not keep secrets in YAML files.

## Required tooling

- Terraform >= 1.6.0
- Azure CLI

## Bootstrap

```bash
cd bootstrap
az login
terraform init
terraform plan
terraform apply
```

## Stack deployment

```bash
cd rootstack/sub-prod/rg-net
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

```bash
cd ../rg-paas
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

```bash
cd ../rg-db
terraform init -backend-config=backend.hcl
terraform plan
terraform apply -var="postgres_admin_password=<strong-password>"
```

## Notes

- The PostgreSQL password should ideally be injected from Azure Key Vault or CI/CD secret storage.
- Run `terraform fmt -recursive` before committing changes.
- Use remote state and separate resource groups as shown in the repository structure.
