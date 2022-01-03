
terraform {
  cloud {
    organization = "testigoelectoral"
    workspaces {
      name = "tfcloud-000-setup-tfc"
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