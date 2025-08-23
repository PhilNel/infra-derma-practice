variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "specials_handler_lambda_name" {
  description = "Lambda function name for GET /api/v1/specials"
  type        = string
}

variable "api_gateway_log_level" {
  description = "API Gateway logging level (OFF | ERROR | INFO)"
  type        = string
  default     = "INFO"
}

variable "enable_request_response_logging" {
  description = "Enable full request/response logging"
  type        = bool
  default     = false
}
