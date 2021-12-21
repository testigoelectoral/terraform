
module "workspace_dev" {
  for_each    = local.services
  source      = "./workspace"
  service     = each.value
  key         = each.key
  environment = "dev"
}

module "workspace_stage" {
  for_each    = local.services
  source      = "./workspace"
  service     = each.value
  key         = each.key
  environment = "stage"
}

module "workspace_prod" {
  for_each    = local.services
  source      = "./workspace"
  service     = each.value
  key         = each.key
  environment = "prod"
}
