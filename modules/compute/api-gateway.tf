resource "aws_api_gateway_rest_api" "main" {
  name        = "backend-api-${var.environment}"
  description = "REST API Gateway for application"
}

resource "aws_api_gateway_resource" "version" {
  for_each = toset(var.api_versions)

  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = each.value
}

resource "aws_api_gateway_resource" "users_versioned" {
  for_each = toset(var.api_versions)

  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.version[each.value].id
  path_part   = "users"
}


# GET /v1/users, GET /v2/users
resource "aws_api_gateway_method" "get_users" {
  for_each = toset(var.api_versions)

  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.users_versioned[each.value].id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_users" {
  for_each = toset(var.api_versions)

  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.users_versioned[each.value].id
  http_method = aws_api_gateway_method.get_users[each.value].http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "GET"
  uri                     = "${var.backend_endpoint}/${each.value}/users"

}