# =============================================================================
# GET /api/v1/specials - List Specials endpoint
# =============================================================================

resource "aws_api_gateway_method" "specials_get" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.specials.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "specials_get_200" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.specials.id
  http_method = aws_api_gateway_method.specials_get.http_method
  status_code = "200"

  response_models = {
    "application/json" = aws_api_gateway_model.success_response.name
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}