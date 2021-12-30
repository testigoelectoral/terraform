
# Environment definition copy this file on all services
variable "environment" {
  type = string
}

terraform {
  cloud {
    organization = "testigoelectoral"
    workspaces {
      tags = ["certs"]
    }
  }
}

locals {

  # Map between environment and region
  region_environment = {
    "prod"  = "us-east-2" # Ohio
    "stage" = "us-east-1" # Virginia
    "dev"   = "us-west-1" # Oregon
  }

  # Actual region
  region = local.region_environment[var.environment]
}

provider "aws" {
  region = local.region
}

# Required for global certificates
provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}
