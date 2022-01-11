
module "workspace_dev" {
  for_each    = local.services
  source      = "./workspace"
  service     = each.key
  key         = each.value
  environment = "dev"
}

module "workspace_stage" {
  for_each    = local.services
  source      = "./workspace"
  service     = each.key
  key         = each.value
  environment = "stage"
}

module "workspace_prod" {
  for_each    = local.services
  source      = "./workspace"
  service     = each.key
  key         = each.value
  environment = "prod"
}


module "api_deployment_dev" {
  source      = "./api-deployment"
  ws_ids      = [for k, v in local.services : module.workspace_dev[k].ws_id if length(regexall("^api-", k)) > 0]
  environment = "dev"
  depends_on = [
    module.workspace_dev
  ]
}

module "api_deployment_stage" {
  source      = "./api-deployment"
  ws_ids      = [for k, v in local.services : module.workspace_stage[k].ws_id if length(regexall("^api-", k)) > 0]
  environment = "stage"
  depends_on = [
    module.workspace_stage
  ]
}

module "api_deployment_prod" {
  source      = "./api-deployment"
  ws_ids      = [for k, v in local.services : module.workspace_prod[k].ws_id if length(regexall("^api-", k)) > 0]
  environment = "prod"
  depends_on = [
    module.workspace_prod
  ]
}
