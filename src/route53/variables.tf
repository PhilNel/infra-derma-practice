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

variable "squarespace_ip_addresses" {
  description = "List of SquareSpace IP addresses for A records"
  type        = list(string)

  validation {
    condition = alltrue([
      for ip in var.squarespace_ip_addresses : can(regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}$", ip))
    ])
    error_message = "All IP addresses must be valid IPv4 addresses."
  }
}

variable "squarespace_cname_target" {
  description = "SquareSpace CNAME target for www subdomain"
  type        = string
  default     = "ext-cust.squarespace.com"
}

variable "cloudfront_distribution_domain_name" {
  description = "CloudFront distribution domain name (for future use)"
  type        = string
}

variable "cloudfront_hosted_zone_id" {
  description = "CloudFront hosted zone ID (constant: Z2FDTNDATAQYW2)"
  type        = string
  default     = "Z2FDTNDATAQYW2"
}

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "af-south-1"
} 