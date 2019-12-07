resource "aws_ecr_repository" "dropecr" {
  name = "droprepo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}