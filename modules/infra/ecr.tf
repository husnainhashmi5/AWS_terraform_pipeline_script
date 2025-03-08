# Create ECR Container Registry with the code bellow:
resource "aws_ecr_repository" "aws_ecr" {
  name = "${var.app_name}-${var.app_environment}-ecr"

  # image_tag_mutability is set to be MUTABLE. This is necessary in order to put a latest tag on the most recent image.
  image_tag_mutability = "MUTABLE"

  # Useful to detect any vulnerability in your docker image.
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "${var.app_name}-ecr",
    Environment = var.app_environment
  }
}

# Lifecycle policy to make sure, not many version of the same image is created
resource "aws_ecr_lifecycle_policy" "ecr-policy" {
  repository = aws_ecr_repository.aws_ecr.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "keep last 10 images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 10
      }
    }]
  })

}
