locals {
  environment        = split("_", terraform.workspace)[0]
  aws_region         = split("_", terraform.workspace)[1]
  organization       = var.tags["Organization"] != null ? var.tags["Organization"] : "unknown"
  project_name       = var.tags["Project"] != null ? var.tags["Project"] : "unknown"
  expiration_in_days = local.environment == "production" ? 30 : 1
  max_image_count    = local.environment == "production" ? 10 : 3

  tags = merge(var.tags, {
    Project = local.project_name
  })
}

locals {
  docker_dirs = toset([
    for dockerfile in fileset(path.cwd, "*/Dockerfile") :
    dirname(dockerfile)
  ])
}