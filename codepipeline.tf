
resource "aws_codepipeline" "ecs-pipeline" {
  name     = "tf-pipeline"
  role_arn = aws_iam_role.role_ecs-pipeline.arn

  artifact_store {
    location = aws_s3_bucket.bucket_artifacts.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceArtifact"]
      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.ecs-pipeline.arn
        BranchName       = "master"
        FullRepositoryId = var.github_repo
      }
      region    = var.aws_region
      namespace = "SourceVariables"
      run_order = 1
    }
  }

  stage {
    name = "Frontend"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["SourceArtifact"]
      configuration = {
        ProjectName = aws_codebuild_project.project_frontend.name
      }
      region    = var.aws_region
      namespace = "Frontend"
      run_order = 1
    }
  }

  stage {
    name = "Backend"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["SourceArtifact"]
      configuration = {
        ProjectName = aws_codebuild_project.project_frontend.name
      }
      region    = var.aws_region
      namespace = "Backend"
      run_order = 1
    }
  }
}




resource "aws_codestarconnections_connection" "ecs-pipeline" {
  name          = "ecs-pipeline"
  provider_type = "GitHub"
}