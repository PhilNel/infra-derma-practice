include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "../../src/derma-website-api"
}

locals {
  base = include.root.locals
}

inputs = {
  aws_region  = local.base.aws_region
  environment = local.base.environment

  specials_handler_lambda_name = "go-derma-specials-handler-${local.base.environment}"
}


