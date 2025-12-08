resource "aws_api_gateway_rest_api" "rest_api" {
  name        = "rest-api-gateway"
  description = "REST API Gateway for application"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy_method" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "proxy_integration" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy_method.http_method
  type        = "MOCK"
  integration_http_method = "ANY"
}

resource "aws_api_gateway_deployment" "rest_deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id

  depends_on = [
    aws_api_gateway_integration.proxy_integration
  ]
}

output "rest_api_invoke_url" {
  value       = "https://${aws_api_gateway_rest_api.rest_api.id}.execute-api.${var.region}.amazonaws.com/${aws_api_gateway_deployment.rest_deployment.stage_name}/"
  description = "Invoke URL of the REST API Gateway endpoint"
}

