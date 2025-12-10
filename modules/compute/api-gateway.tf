# Cloud Map service
resource "aws_service_discovery_private_dns_namespace" "main" {
  name = "internal"
  vpc  = aws_vpc.main.id
  description = "Private DNS namespace for service discovery"
}

resource "aws_service_discovery_service" "main" {
  name = "ec2-backend"
  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id
    dns_records {
      type = "A"
      ttl  = 10
    }
    routing_policy = "MULTIVALUE"
  }
}

resource "aws_service_discovery_instance" "main" {
  instance_id = aws_instance.main.id
  service_id  = aws_service_discovery_service.main.id

  attributes = {
    AWS_INSTANCE_IPV4 = aws_instance.main.private_ip
    AWS_INSTANCE_PORT = "80"
  }
}

resource "aws_apigatewayv2_vpc_link" "main" {
  name               = "http-api-vpc-link"
  subnet_ids         = aws_subnet.private[*].id
  security_group_ids = [aws_security_group.api_gw_to_ec2.id]
}

resource "aws_apigatewayv2_api" "main" {
  name          = "backend-http-api-${var.environment}"
  protocol_type = "HTTP"
  description   = "HTTP API Gateway for application using Cloud Map"
}

resource "aws_apigatewayv2_route" "users" {
  for_each     = toset(var.api_versions)
  api_id       = aws_apigatewayv2_api.main.id
  route_key    = "GET /${each.value}/users"
  target       = "integrations/${aws_apigatewayv2_integration.users[each.value].id}"
}

resource "aws_apigatewayv2_integration" "users" {
  for_each                = toset(var.api_versions)
  api_id                  = aws_apigatewayv2_api.main.id
  integration_type        = "HTTP"
  integration_method      = "GET"
  integration_uri         = "http://ec2-backend.internal:80"
  connection_type         = "VPC_LINK"
  connection_id           = aws_apigatewayv2_vpc_link.main.id
  payload_format_version  = "1.0"
  timeout_milliseconds    = 30000
  request_parameters      = {}
}
