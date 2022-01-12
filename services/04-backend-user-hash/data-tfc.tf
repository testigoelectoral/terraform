
data "tfe_outputs" "setup" {
  organization = local.org
  workspace    = "tfcloud-000-setup-tfc"
}

data "tfe_outputs" "s3" {
  organization = local.org
  workspace    = data.tfe_outputs.setup.values.ws_name[var.environment]["s3"]
}

data "tfe_outputs" "kms" {
  organization = local.org
  workspace    = data.tfe_outputs.setup.values.ws_name[var.environment]["kms"]
}
