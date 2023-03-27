resource "aws_ecs_service" "FrontendService" {
  name                               = "test"
  cluster                            = "arn:aws:ecs:ap-northeast-1:763397213391:cluster/test"
  desired_count                      = 1
  launch_type                        = "EC2"
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
}

resource "aws_ecs_service" "BackendService" {
  name                               = "test"
  cluster                            = "arn:aws:ecs:ap-northeast-1:763397213391:cluster/test"
  desired_count                      = 1
  launch_type                        = "EC2"
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
}

resource "aws_ecs_cluster" "ECSCluster" {
  name = "test"
}