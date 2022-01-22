
locals {
  org       = "testigoelectoral"
  dev_ids   = nonsensitive([for k, v in data.tfe_outputs.setup.values.ws_name.dev : v.id if length(regexall("^api-", k)) > 0])
  stage_ids = nonsensitive([for k, v in data.tfe_outputs.setup.values.ws_name.stage : v.id if length(regexall("^api-", k)) > 0])
  prod_ids  = nonsensitive([for k, v in data.tfe_outputs.setup.values.ws_name.prod : v.id if length(regexall("^api-", k)) > 0])
}
