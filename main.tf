variable "aws_region" {}
variable "access_key" {}
variable "secret_key" {}
variable "github_token" {}
variable "github_owner" {}
variable "github_repo" {}

provider "github" {
  token = var.github_token
  owner = var.github_owner
}

data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}