include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "git::https://github.com/PhilNel/infra-shared-lib.git//terraform/static-website?ref=main"
}

locals {
  base = include.root.locals
}

inputs = {
  environment               = local.base.environment
  bucket_name               = "${local.base.project_name}-${local.base.environment}-${local.base.aws_region}"
  enable_cloudfront         = true
  cloudfront_price_class    = "PriceClass_100"
}