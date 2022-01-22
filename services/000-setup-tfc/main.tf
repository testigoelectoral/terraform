
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
