resource "aws_codebuild_project" "project_frontend" {
  name          = "frontend-project"
  description   = "Analyze the code for vulnerabilities using frontend."
  service_role  = aws_iam_role.role_frontend.arn
  build_timeout = 60

  source {
    type      = "CODEPIPELINE"
    buildspec = <<-EOF
      version: 0.2
      phases:
        pre_build:
          commands:
            - echo Executing frontend
            - cd client
            - npm install
        build:
          commands:
            - npm run build
        post_build:
          commands:
            - aws s3 sync build/ s3://${aws_s3_bucket.frontend.id} --delete
            - aws cloudfront create-invalidation --distribution-id ${aws_cloudfront_distribution.mern.id} --paths "/*"
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
    Name = "frontend-project"
  }
}