
variable "service" {
  type = string
}

variable "key" {
  type = string
}

variable "environment" {
  type = string
}

locals {
  org   = "testigoelectoral"
  repo  = "testigoelectoral/terraform"
  oauth = "ot-KWJXQyRwAq71FZaa"
}

output "ws_id" {
  value = tfe_workspace.ws.id
}

output "ws_name" {
  value = tfe_workspace.ws.name
}
