resource "aws_ecs_service" "FrontendService" {
  name                               = "frontend"
  cluster                            = aws_ecs_cluster.ECSCluster.arn
  desired_count                      = 1
  task_definition                    = aws_ecs_task_definition.FrontendTaskDefinition.arn
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }
  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
  scheduling_strategy = "REPLICA"
  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.frontend.name
    base              = 1
    weight            = 1
  }
}

resource "aws_ecs_service" "BackendService" {
  name                               = "backend"
  cluster                            = aws_ecs_cluster.ECSCluster.arn
  desired_count                      = 1
  task_definition                    = aws_ecs_task_definition.BackendTaskDefinition.arn
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }
  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
  scheduling_strategy = "REPLICA"
  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.backend.name
    base              = 1
    weight            = 1
  }
}

resource "aws_ecs_cluster" "ECSCluster" {
  name = "mern"
}

resource "aws_ecs_capacity_provider" "frontend" {
  name = "frontend"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.frontend.arn

    managed_scaling {
      maximum_scaling_step_size = 1
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }
}

resource "aws_ecs_capacity_provider" "backend" {
  name = "backend"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.backend.arn

    managed_scaling {
      maximum_scaling_step_size = 1
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }
}
