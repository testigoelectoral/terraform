
data "tfe_outputs" "setup" {
  organization = local.org
  workspace    = "tfcloud-000-setup-tfc"
}

data "tfe_outputs" "certs" {
  organization = local.org
  workspace    = data.tfe_outputs.setup.values.ws_name[var.environment]["certs"].name
}
