variable "migration_ttl" {
  description = "TTL in seconds for DNS records during migration (low for easy testing)"
  type        = number
  default     = 300

  validation {
    condition     = var.migration_ttl >= 60 && var.migration_ttl <= 86400
    error_message = "TTL must be between 60 seconds and 1 day (86400 seconds)."
  }
}

variable "production_ttl" {
  description = "TTL in seconds for DNS records in production (higher for performance)"
  type        = number
  default     = 3600

  validation {
    condition     = var.production_ttl >= 300 && var.production_ttl <= 86400
    error_message = "Production TTL must be between 5 minutes (300 seconds) and 1 day (86400 seconds)."
  }
}

variable "cloudfront_distribution_domain_name" {
  description = "CloudFront distribution domain name (for future use)"
  type        = string
}

variable "nelskin_redirect_cloudfront_domain_name" {
  description = "CloudFront domain name for nelskin.co.za redirect"
  type        = string
}

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "af-south-1"
} 