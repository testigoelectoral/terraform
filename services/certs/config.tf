
# Environment definition copy this file on all services

# Make sure this variable has the actual service name (same folder name)
locals {
  service = "certs"
}

locals {
  # Map between workspace and actual environment
  environment_workspace = {
    "${local.service}-dev" = "dev"
    "${local.service}-stage" = "stage"
    "${local.service}-prod" = "prod"
    "default" = "dev"
  }
  # Actual environment
  environment = local.environment_workspace[terraform.workspace]

  # Map between environment and region
  region_environment = {
    "prod" = "us-east-2" # Ohio
    "stage" = "us-east-1" # Virginia
    "dev" = "us-west-1" # Oregon
  }

  # Actual region
  region = local.region_environment[local.environment]
}

provider "aws" {
  region = local.region
}
