
terraform {
  cloud {
    organization = "testigoelectoral"
    workspaces {
      name = "tfcloud-001-api-deployment"
    }
  }
}

variable "account_id" {
  type = string
}

provider "tfe" {
  token = var.token
}

variable "token" {
  type = string
}