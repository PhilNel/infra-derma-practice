include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "git::https://github.com/PhilNel/infra-shared-lib.git//terraform/artefacts?ref=${local.base.shared_lib_version}"
}

locals {
  base = include.root.locals
}


inputs = {
  environment = local.base.environment
  aws_region  = local.base.aws_region
  bucket_name = local.base.artefact_bucket_name
} 