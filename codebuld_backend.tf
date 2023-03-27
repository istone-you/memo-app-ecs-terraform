resource "aws_codebuild_project" "project_backend" {
  name          = "backend-project"
  description   = "Analyze the code for vulnerabilities using backend."
  service_role  = aws_iam_role.role_backend.arn
  build_timeout = 60

  source {
    type      = "CODEPIPELINE"
    buildspec = <<-EOF
      version: 0.2
      phases:
        pre_build:
          commands:
            - "echo Executing backend"
            - "cd client"
        build:
          commands:
            - "docker build -t backend ."
        post_build:
          commands:
            - "aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
            - "docker tag backend:latest ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/backend:latest"
            - "docker push ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/backend:latest"
            - echo Writing image definitions file...
            - echo "[{\"name\":\"backend\",\"imageUri\":\"${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/backend:latest\"}]" > ../imagedefinitions.json
      artifacts:
          files: imagedefinitions.json
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
    privileged_mode             = true

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