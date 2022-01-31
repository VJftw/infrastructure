# infrastructure

[![Terraform: Main](https://github.com/VJftw/infrastructure/actions/workflows/terraform_main.yml/badge.svg?branch=main)](https://github.com/VJftw/infrastructure/actions/workflows/terraform_main.yml)

Organisational infrastructure for my projects

## Design

### Accounts

Accounts should only be created in this repository, where other repositories will reference accounts created here. This is because accounts are long-lasting entities so it is preferable that we have a central location where they are created. 

When a new account is added to be created, many Terraform roots will fail as the account won't exist yet, possible solutions:
 * "blind" pipeline with pre-approved plans via OPA + Terraform. The pipeline will apply things in order as long as they are pre-approved.
 * use of a flag, manual pipeline. 

pipeline sounds best.

TODO:
 * Integrate OPA + Terraform w/ this repo
 * PRs
   * 1. `terraform plan -refresh=false -lock=false -out=tfplan.out`, this should let us plan for accounts which don't exist yet as providers won't need auth to refresh.
   * 2. Validate plan using OPA.
 * Pipeline will be accounts -> all others
 * Add `deployment/environments` for TF that iterates per environment
 * Add `deployment/accounts/aws/audit` for cloudtrail
    * Add `modules/logs/archive` for archive S3 bucket
    * Add `accounts/aws/vjp-archive.tfvars` for archive S3 buckets
