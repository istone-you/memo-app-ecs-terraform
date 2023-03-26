resource "aws_codebuild_project" "project_backend" {
  name          = "backend-project"
  description   = "Analyze the code for vulnerabilities using backend."
  service_role  = aws_iam_role.role_backend.arn
  build_timeout = 60

  source {
    type      = "CODEPIPELINE"
    buildspec = <<-EOF
      version: 0.2
      env:
        exported-variables:
          - BuildID
          - BuildTag
      phases:
        pre_build:
          commands:
            - "echo Executing backend"
        build:
          commands:
            - ""
        post_build:
          commands:
            - ""
    EOF
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type = "NO_CACHE"
  }

  environment {
    type                        = "LINUX_CONTAINER"
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false

    environment_variable {
      name  = "access_key"
      type  = "PARAMETER_STORE"
      value = "access_key"
    }

    environment_variable {
      name  = "secret_key"
      type  = "PARAMETER_STORE"
      value = "secret_key"
    }
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
  }
  encryption_key = aws_kms_key.key_s3_artifact.arn

  tags = {
    Name = "backend-project"
  }
}