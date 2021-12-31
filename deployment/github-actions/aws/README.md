# GitHub Actions w/ OIDC on AWS

## Goals

* Configure per reprository-branch permissions on AWS cloud across multiple accounts.

## Commandments 

* The Github Action has an Identity in the form of a singular IAM role. To support authenticating to different accounts, the client must cross-account to that role.
* Authentication should be outside of the Terraform configuration so that it can be re-used.

## Design

Build a tool which generates AWS Profiles: 
```
$ <tool> <account_name> <role_name>
$ tool vjp-management read-only
```

Then use profile in Terraform configuration:
```
provider "aws" {
    profile = "vjp-management"
}
```
