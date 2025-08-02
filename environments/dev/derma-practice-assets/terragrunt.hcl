include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "git::https://github.com/PhilNel/infra-shared-lib.git//terraform/public-assets?ref=${local.base.shared_lib_version}"
}

locals {
  base = include.root.locals
}

inputs = {
  bucket_name                 = "${local.base.project_name}-${local.base.environment}-assets-${local.base.aws_region}"
  cloudfront_distribution_arn = local.base.practice_website_cloudfront_distribution_arn
}