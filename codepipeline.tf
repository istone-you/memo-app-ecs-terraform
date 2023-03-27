
resource "aws_codepipeline" "ecs-pipeline" {
  name     = "ecs-pipeline"
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
    name = "Build"

    action {
      name             = "FrontendBuild"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["FrontendBuildArtifact"]
      configuration = {
        ProjectName = aws_codebuild_project.project_frontend.name
      }
      region    = var.aws_region
      namespace = "Frontend"
      run_order = 1
    }
    action {
      name             = "BackendBuild"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BackendBuildArtifact"]
      configuration = {
        ProjectName = aws_codebuild_project.project_frontend.name
      }
      region    = var.aws_region
      namespace = "Backend"
      run_order = 1
    }
  }

  stage {
    name = "FrontendDeploy"
    action {
      name            = "FrontendDeploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = 1
      input_artifacts = ["FrontendBuildArtifact"]
      configuration = {
        ClusterName = aws_ecs_cluster.ECSCluster.name
        ServiceName = aws_ecs_service.FrontendService.name
      }
    }
    action {
      name            = "BackendendDeploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = 1
      input_artifacts = ["BackendBuildArtifact"]
      configuration = {
        ClusterName = aws_ecs_cluster.ECSCluster.name
        ServiceName = aws_ecs_service.BackendService.name
      }
    }
  }
}




resource "aws_codestarconnections_connection" "ecs-pipeline" {
  name          = "ecs-pipeline"
  provider_type = "GitHub"
}