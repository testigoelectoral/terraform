variable "environment" {
  type = string
}

variable "ws_ids" {
  type = set(string)
}

locals {
  org   = "testigoelectoral"
  repo  = "testigoelectoral/terraform"
  oauth = "ot-KWJXQyRwAq71FZaa"
}
