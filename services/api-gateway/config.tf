
# Environment definition copy this file on all services
variable environment {
  type = string
}

terraform {
  backend "remote" {
    organization = "testigoelectoral"
    workspaces {
      prefix = "api-gateway-"
    }
  }
}

locals {

  # Map between environment and region
  region_environment = {
    "prod" = "us-east-2" # Ohio
    "stage" = "us-east-1" # Virginia
    "dev" = "us-west-1" # Oregon
  }

  # Actual region
  region = local.region_environment[var.environment]
}

provider "aws" {
  region = local.region
}
