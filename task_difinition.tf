
resource "aws_ecs_task_definition" "FrontendTaskDefinition" {
  container_definitions = "[{\"name\":\"former2\",\"image\":\"763397213391.dkr.ecr.ap-northeast-1.amazonaws.com/example\",\"cpu\":0,\"memory\":250,\"portMappings\":[{\"containerPort\":80,\"hostPort\":80,\"protocol\":\"tcp\"}],\"essential\":true,\"environment\":[],\"mountPoints\":[],\"volumesFrom\":[],\"logConfiguration\":{\"logDriver\":\"awsfirelens\"}},{\"name\":\"log_router\",\"image\":\"763397213391.dkr.ecr.ap-northeast-1.amazonaws.com/firelens:latest\",\"cpu\":0,\"memoryReservation\":50,\"portMappings\":[],\"essential\":false,\"entryPoint\":[],\"command\":[],\"environment\":[],\"mountPoints\":[],\"volumesFrom\":[],\"secrets\":[{\"name\":\"GRAFANA_API\",\"valueFrom\":\"grafana_cloud_api_key\"}],\"user\":\"0\",\"logConfiguration\":{\"logDriver\":\"awslogs\",\"options\":{\"awslogs-group\":\"/ecs/former2\",\"awslogs-region\":\"ap-northeast-1\",\"awslogs-stream-prefix\":\"ecs\"}},\"firelensConfiguration\":{\"type\":\"fluentbit\",\"options\":{\"config-file-type\":\"file\",\"config-file-value\":\"/fluent-bit/etc/extra.conf\"}}},{\"name\":\"node_exporter\",\"image\":\"quay.io/prometheus/node-exporter:latest\",\"cpu\":0,\"memoryReservation\":50,\"portMappings\":[{\"containerPort\":9100,\"hostPort\":9100,\"protocol\":\"tcp\"}],\"essential\":false,\"entryPoint\":[],\"command\":[\"--path.rootfs=/host\"],\"environment\":[],\"mountPoints\":[],\"volumesFrom\":[]},{\"name\":\"adot-collector\",\"image\":\"763397213391.dkr.ecr.ap-northeast-1.amazonaws.com/aws-otel-collector:latest\",\"cpu\":0,\"memoryReservation\":50,\"portMappings\":[{\"containerPort\":55680,\"hostPort\":55680,\"protocol\":\"tcp\"}],\"essential\":true,\"entryPoint\":[],\"command\":[],\"environment\":[],\"mountPoints\":[],\"volumesFrom\":[],\"logConfiguration\":{\"logDriver\":\"awsfirelens\"}}]"
  family                = "frontend"
  task_role_arn         = "arn:aws:iam::763397213391:role/ecsTaskExecutionRole"
  execution_role_arn    = "arn:aws:iam::763397213391:role/ecsTaskExecutionRole"
  network_mode          = "host"
  volume {
    name      = "root"
    host_path = "/"
  }
  volume {
    name      = "var_run"
    host_path = "/var/run"
  }
  volume {
    name      = "sys"
    host_path = "/sys"
  }
  volume {
    name      = "var_lib_docker"
    host_path = "/var/lib/docker/"
  }
  requires_compatibilities = [
    "EC2"
  ]
  cpu    = "256"
  memory = "512"
}

resource "aws_ecs_task_definition" "BackendTaskDefinition" {
  container_definitions = "[{\"name\":\"former2\",\"image\":\"763397213391.dkr.ecr.ap-northeast-1.amazonaws.com/example\",\"cpu\":0,\"memory\":250,\"portMappings\":[{\"containerPort\":80,\"hostPort\":80,\"protocol\":\"tcp\"}],\"essential\":true,\"environment\":[],\"mountPoints\":[],\"volumesFrom\":[],\"logConfiguration\":{\"logDriver\":\"awsfirelens\"}},{\"name\":\"log_router\",\"image\":\"763397213391.dkr.ecr.ap-northeast-1.amazonaws.com/firelens:latest\",\"cpu\":0,\"memoryReservation\":50,\"portMappings\":[],\"essential\":false,\"entryPoint\":[],\"command\":[],\"environment\":[],\"mountPoints\":[],\"volumesFrom\":[],\"secrets\":[{\"name\":\"GRAFANA_API\",\"valueFrom\":\"grafana_cloud_api_key\"}],\"user\":\"0\",\"logConfiguration\":{\"logDriver\":\"awslogs\",\"options\":{\"awslogs-group\":\"/ecs/former2\",\"awslogs-region\":\"ap-northeast-1\",\"awslogs-stream-prefix\":\"ecs\"}},\"firelensConfiguration\":{\"type\":\"fluentbit\",\"options\":{\"config-file-type\":\"file\",\"config-file-value\":\"/fluent-bit/etc/extra.conf\"}}},{\"name\":\"node_exporter\",\"image\":\"quay.io/prometheus/node-exporter:latest\",\"cpu\":0,\"memoryReservation\":50,\"portMappings\":[{\"containerPort\":9100,\"hostPort\":9100,\"protocol\":\"tcp\"}],\"essential\":false,\"entryPoint\":[],\"command\":[\"--path.rootfs=/host\"],\"environment\":[],\"mountPoints\":[],\"volumesFrom\":[]},{\"name\":\"adot-collector\",\"image\":\"763397213391.dkr.ecr.ap-northeast-1.amazonaws.com/aws-otel-collector:latest\",\"cpu\":0,\"memoryReservation\":50,\"portMappings\":[{\"containerPort\":55680,\"hostPort\":55680,\"protocol\":\"tcp\"}],\"essential\":true,\"entryPoint\":[],\"command\":[],\"environment\":[],\"mountPoints\":[],\"volumesFrom\":[],\"logConfiguration\":{\"logDriver\":\"awsfirelens\"}}]"
  family                = "backend"
  task_role_arn         = "arn:aws:iam::763397213391:role/ecsTaskExecutionRole"
  execution_role_arn    = "arn:aws:iam::763397213391:role/ecsTaskExecutionRole"
  network_mode          = "host"
  volume {
    name      = "root"
    host_path = "/"
  }
  volume {
    name      = "var_run"
    host_path = "/var/run"
  }
  volume {
    name      = "sys"
    host_path = "/sys"
  }
  volume {
    name      = "var_lib_docker"
    host_path = "/var/lib/docker/"
  }
  requires_compatibilities = [
    "EC2"
  ]
  cpu    = "256"
  memory = "512"
}
