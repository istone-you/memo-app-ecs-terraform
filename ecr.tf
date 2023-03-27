resource "aws_ecr_repository" "FrontendRepository" {
  name = "frontend"
}

resource "aws_ecr_repository" "BackendRepository" {
  name = "backend"
}