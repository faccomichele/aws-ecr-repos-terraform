# aws-ecr-repos-terraform

Terraform centralised IaC for AWS ECR repositories.

## Repository discovery

Repositories are discovered from the Terraform working directory (`path.cwd`). Each immediate child directory containing an exact-case `Dockerfile` is used as an ECR repository key. Dockerfiles in the working directory itself or in deeper nested directories are ignored.

At least one matching directory is required. Planning fails when no matching directories are found, preventing an empty discovery result from removing all managed repositories.
