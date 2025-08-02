include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "git::https://github.com/PhilNel/infra-shared-lib.git//terraform/static-website?ref=${local.base.shared_lib_version}"
}

locals {
  base = include.root.locals
  one_year_ttl = 31536000 # 1 year in seconds
}

dependency "assets" {
  config_path = "../derma-practice-assets"
}

dependency "certificates" {
  config_path = "../certificates"
  
  mock_outputs = {
    certificate_arns = {
      "*.nelskincare.co.za" = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
    }
  }
}

inputs = {
  environment               = local.base.environment
  bucket_name               = "${local.base.project_name}-${local.base.environment}-${local.base.aws_region}"
  enable_cloudfront         = true
  cloudfront_price_class    = "PriceClass_100"
  domain_name               = "nelskincare.co.za"
  certificate_arn           = dependency.certificates.outputs.certificate_arns["*.nelskincare.co.za"]
  
  cache_behavior_config = {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    min_ttl         = 0
    default_ttl     = local.one_year_ttl
    max_ttl         = local.one_year_ttl
  }

  additional_origins = [
    {
      domain_name              = dependency.assets.outputs.bucket_regional_domain_name
      origin_id                = "assets-origin"
      path_pattern             = "/images/*"
      origin_access_control_id = dependency.assets.outputs.origin_access_control_id
      cache_behavior = {
        allowed_methods = ["GET", "HEAD", "OPTIONS"]
        min_ttl         = 0
        default_ttl     = local.one_year_ttl
        max_ttl         = local.one_year_ttl
      }
    }
  ]
}