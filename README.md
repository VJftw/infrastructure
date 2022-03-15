# infrastructure

[![Terraform: Main](https://github.com/VJftw/infrastructure/actions/workflows/terraform_main.yml/badge.svg?branch=main)](https://github.com/VJftw/infrastructure/actions/workflows/terraform_main.yml)

Organisational infrastructure for my projects

## Design

### Accounts

Accounts should only be created in this repository, where other repositories will reference accounts created here. This is because accounts are long-lasting entities so it is preferable that we have a central location where they are created. 

### Environments

Environments should only be created in this repository as only accounts within this repository will reference them. These are intentionally basic to prevent cognitive-creep and complexity from an infrastructure PoV.

### Roles

Roles should only be created in this repository as only identities within this repository will reference them. These are intentionally basic to prevent cognitive-creep and complexity from an infrastructure PoV. 
