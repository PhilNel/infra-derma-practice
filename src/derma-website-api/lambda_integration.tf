# =============================================================================
# GET /api/v1/specials - List Specials lambda integration
# =============================================================================

resource "aws_api_gateway_integration" "specials_get" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.specials.id
  http_method             = aws_api_gateway_method.specials_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${data.aws_lambda_function.specials.arn}/invocations"

  timeout_milliseconds = 29000
}

resource "aws_api_gateway_integration_response" "specials_get_200" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.specials.id
  http_method = aws_api_gateway_method.specials_get.http_method
  status_code = aws_api_gateway_method_response.specials_get_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,x-api-key,Authorization'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET'"
  }
}

resource "aws_lambda_permission" "api_gateway_invoke_specials" {
  statement_id  = "AllowExecutionFromAPIGatewaySpecials"
  action        = "lambda:InvokeFunction"
  function_name = var.specials_handler_lambda_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.main.execution_arn}/*/*"
}
