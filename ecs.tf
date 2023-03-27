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

resource "aws_autoscaling_group" "frontend" {
  name             = "ecs-frontend-asg"
  min_size         = 1
  max_size         = 1
  desired_capacity = 1

  launch_configuration = aws_launch_configuration.ecs.name
  vpc_zone_identifier  = ["subnet-09d45d5b0722e6315"]

  service_linked_role_arn = "arn:aws:iam::763397213391:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"

  tags = [
    {
      key                 = "AmazonECSManaged"
      propagate_at_launch = true
      value               = ""
    }
  ]
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

resource "aws_autoscaling_group" "backend" {
  name             = "ecs-backend-asg"
  min_size         = 1
  max_size         = 1
  desired_capacity = 1

  launch_configuration = aws_launch_configuration.ecs.name
  vpc_zone_identifier  = ["subnet-09d45d5b0722e6315"]

  service_linked_role_arn = "arn:aws:iam::763397213391:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"

  tags = [
    {
      key                 = "AmazonECSManaged"
      propagate_at_launch = true
      value               = ""
    }
  ]
}

resource "aws_launch_configuration" "ecs" {
  name_prefix   = "ecs-launch-tf-"
  image_id      = "ami-09c4258ce9b81642c"
  instance_type = "t2.medium"

  security_groups = [
    "sg-00e7cdcedbd89dc4a"
  ]
  enable_monitoring    = true
  iam_instance_profile = "arn:aws:iam::763397213391:instance-profile/ECS-SSM"

  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=mern >> /etc/ecs/ecs.config
EOF

  associate_public_ip_address = true
}