include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "git::https://github.com/PhilNel/infra-shared-lib.git//terraform/static-website?ref=develop"
}

locals {
  base = include.root.locals
}

dependency "assets" {
  config_path = "../derma-practice-assets"
}

inputs = {
  environment               = local.base.environment
  bucket_name               = "${local.base.project_name}-${local.base.environment}-${local.base.aws_region}"
  enable_cloudfront         = true
  cloudfront_price_class    = "PriceClass_100"
  
  additional_origins = [
    {
      domain_name              = dependency.assets.outputs.bucket_regional_domain_name
      origin_id                = "assets-origin"
      path_pattern             = "/images/*"
      origin_access_control_id = dependency.assets.outputs.origin_access_control_id
    }
  ]
}