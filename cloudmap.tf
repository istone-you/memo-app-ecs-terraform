resource "aws_service_discovery_service" "backend" {
  name = "backend"
  dns_config {
    dns_records {
      ttl  = 60
      type = "SRV"
    }

    namespace_id   = aws_service_discovery_private_dns_namespace.Namespace.id
    routing_policy = "MULTIVALUE"
  }
  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_service_discovery_private_dns_namespace" "Namespace" {
  name = "mern"
  vpc  = "vpc-0eb73ecf664320261"
}