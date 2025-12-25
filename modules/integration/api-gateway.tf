
resource "aws_apigatewayv2_api" "main" {
  name          = "backend-http-api-${var.environment}"
  protocol_type = "HTTP"
}


# VPC Link (needed to connect API Gateway to ALB)
resource "aws_apigatewayv2_vpc_link" "vpc_link" {
  name        = "api-to-alb-vpc-link"
  subnet_ids  = [var.private_subnet_id]
  security_group_ids = [var.alb_security_group_id]
}

# Integration: API Gateway → ALB
resource "aws_apigatewayv2_integration" "alb_integration" {
  api_id = aws_apigatewayv2_api.main.id
  integration_type       = "HTTP_PROXY"
  integration_uri        = "https://${aws_lb.app_alb.dns_name}"  # ALB DNS
  connection_type        = "VPC_LINK"
  connection_id          = aws_apigatewayv2_vpc_link.vpc_link.id
  payload_format_version = "1.0"
}

# Simple default route
resource "aws_apigatewayv2_route" "default" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.alb_integration.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default"
  auto_deploy = true
}