resource "aws_ecr_repository" "this" {
  for_each             = toset(var.service_names)
  name                 = "${var.project}-${var.environment}/${each.key}"
  image_tag_mutability = var.image_mutability
  force_delete         = true # Allows Terraform to destroy the repo even if it contains images

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.project}-${var.environment}/${each.key}"
  }
}

resource "aws_ecr_lifecycle_policy" "this" {
  for_each   = aws_ecr_repository.this
  repository = each.value.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images to manage storage costs"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
