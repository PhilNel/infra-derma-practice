include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "../../../src//route53"
}

locals {
  base = include.root.locals
}

inputs = {
  aws_region = local.base.aws_region

  cloudfront_distribution_domain_name     = "d1i2lnqxrjncsh.cloudfront.net"
  nelskin_redirect_cloudfront_domain_name = "d3qsutpnmrnnyf.cloudfront.net"

  # DNS record configuration for migration
  migration_ttl  = 300  # 5 minutes for easy testing during migration
  production_ttl = 3600  # 1 hour for stable production
}