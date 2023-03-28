
resource "aws_autoscaling_group" "backend" {
  name             = "ecs-backend-asg"
  min_size         = 1
  max_size         = 1
  desired_capacity = 1

  launch_configuration = aws_launch_configuration.ecs.name
  vpc_zone_identifier  = ["subnet-09d45d5b0722e6315"]

  service_linked_role_arn = "arn:aws:iam::763397213391:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"

  tag {
    key                 = "AmazonECSManaged"
    propagate_at_launch = true
    value               = ""
  }
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