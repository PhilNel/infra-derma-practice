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

  cloudfront_distribution_domain_name = "d1i2lnqxrjncsh.cloudfront.net"

  # DNS record configuration for migration
  migration_ttl  = 300  # 5 minutes for easy testing during migration
  production_ttl = 3600  # 1 hour for stable production
  
  # Current SquareSpace configuration
  squarespace_ip_addresses = [
    "198.49.23.144",
    "198.49.23.145",
    "198.185.159.144",
    "198.185.159.145"
  ]
  squarespace_cname_target = "ext-cust.squarespace.com"
}