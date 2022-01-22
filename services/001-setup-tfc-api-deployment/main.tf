
module "api_deployment_dev" {
  source      = "./api-deployment"
  ws_ids      = local.dev_ids
  environment = "dev"
}

module "api_deployment_stage" {
  source      = "./api-deployment"
  ws_ids      = local.stage_ids
  environment = "stage"
}

module "api_deployment_prod" {
  source      = "./api-deployment"
  ws_ids      = local.prod_ids
  environment = "prod"
}
