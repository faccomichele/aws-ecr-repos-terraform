# aws-ecr-repos-terraform

Terraform centralised IaC for AWS ECR repositories.

## Usage

This repository is an overlay for the reusable repository's `terraform-run` workflow. Use that workflow's features and execution context when applying these Terraform definitions; this repository is not intended to be initialized or run standalone.

## Repository discovery

Repositories are discovered from the Terraform working directory (`path.cwd`). Each immediate child directory containing an exact-case `Dockerfile` is used as an ECR repository key. Dockerfiles in the working directory itself or in deeper nested directories are ignored.

At least one matching directory is required. Planning fails when no matching directories are found, preventing an empty discovery result from removing all managed repositories.
