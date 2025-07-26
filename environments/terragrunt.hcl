remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = "nelskin-practice-terraform-state-af-south-1"
    key            = "dev/${path_relative_to_include()}/terraform.tfstate"
    region         = "af-south-1"
    encrypt        = true
    dynamodb_table = "nelskin-practice-terraform-locks"
  }
}

locals {
  aws_region           = "af-south-1"
  environment          = "dev"
  project_name         = "nelskin-practice"
} 