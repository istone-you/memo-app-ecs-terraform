resource "aws_ecs_service" "BackendService" {
  name                               = "backend"
  cluster                            = aws_ecs_cluster.mern.arn
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
  service_registries {
    registry_arn   = aws_service_discovery_service.backend.arn
    container_name = "backend"
    container_port = "3000"
  }
}



resource "aws_ecs_cluster" "mern" {
  name = "mern"
}

resource "aws_ecs_cluster_capacity_providers" "backend" {
  cluster_name       = aws_ecs_cluster.mern.name
  capacity_providers = [aws_ecs_capacity_provider.backend.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 1
    capacity_provider = aws_ecs_capacity_provider.backend.name
  }
}

resource "aws_ecs_capacity_provider" "backend" {
  name = "backend"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.backend.arn
  }
}
