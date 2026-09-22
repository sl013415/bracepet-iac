# breacepet-iac

Enterprise Azure Terraform infrastructure for the BreacePet application.

## Repository layout

```text
bootstrap/              Terraform state storage bootstrap
modules/                Reusable Terraform modules
rootstack/              Environment root stacks
  sub-prod/
    rg-net/
    rg-paas/
    rg-db/
```

## Deployment order

1. Apply `bootstrap/` once to create the remote state storage.
2. Apply `rootstack/sub-prod/rg-net`.
3. Apply `rootstack/sub-prod/rg-paas`.
4. Apply `rootstack/sub-prod/rg-db`.

Azure authentication is expected through Azure CLI locally or OIDC/managed identity in CI/CD. Credentials must not be stored in YAML files.
