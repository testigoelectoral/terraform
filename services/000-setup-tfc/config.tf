
terraform {
  cloud {
    organization = "testigoelectoral"
    workspaces {
      name = "tfcloud-000-setup-tfc"
    }
  }
}

provider "tfe" {
  token = var.token
}

variable token {
  type = string
}