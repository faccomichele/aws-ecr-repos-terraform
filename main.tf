resource "aws_ecr_repository" "this" {
  for_each = local.docker_dirs

  name                 = "${local.project_name}/${each.value}/${local.environment}"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(local.tags,
    {
      File = "main.tf"
    }
  )
}

resource "aws_ecr_lifecycle_policy" "this" {
  for_each = local.docker_dirs
  
  repository = aws_ecr_repository.this[each.key].name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep the latest image"
        selection = {
          tagStatus      = "tagged"
          tagPatternList = ["latest"]
          countType      = "imageCountMoreThan"
          countNumber    = 1
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Expire untagged images after ${local.expiration_in_days} days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = local.expiration_in_days
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 3
        description  = "Expire non-latest images after ${local.expiration_in_days} days"
        selection = {
          tagStatus      = "tagged"
          tagPatternList = ["*"]
          countType      = "sinceImagePushed"
          countUnit      = "days"
          countNumber    = local.expiration_in_days
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 4
        description  = "Keep last ${local.max_image_count} images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = local.max_image_count
        }
        action = {
          type = "expire"
        }
      },
    ]
  })
}

# NOTE!!!
# We can add a rule based on the last pulled date too, if needed:
# {
#   "rules": [
#     {
#       "rulePriority": 1,
#       "description": "Archive images not pulled in 90 days",
#       "selection": {
#         "tagStatus": "any",
#         "countType": "sinceImagePulled",
#         "countUnit": "days",
#         "countNumber": 90
#       },
#       "action": {
#         "type": "transition",
#         "targetStorageClass": "archive"
#       }
#     }
#   ]
# }
