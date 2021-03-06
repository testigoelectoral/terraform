
locals {
  org    = "testigoelectoral"
  domain = "testigoelectoral.org"
}

locals {
  app_domain_environment = {
    "prod"  = "https://app.${local.domain}"
    "dev"   = "https://app-dev.${local.domain}"
    "stage" = "https://app-stage.${local.domain}"
  }
  app_domain      = local.app_domain_environment[var.environment]
  options_domains = var.environment == "dev" ? "*" : local.app_domain
}

locals {
  images_bucket            = data.tfe_outputs.s3.values.bucket_images
  images_bucket_arn        = data.tfe_outputs.s3.values.arn_images
  apigw_id                 = data.tfe_outputs.apigw.values.arn_api
  apigw_root               = data.tfe_outputs.apigw.values.root_id
  cognito_autorizer        = data.tfe_outputs.cognito.values.authorizer_id
  dynamodb_images_arn      = data.tfe_outputs.dynamodb.values.images_arn
  dynamodb_images_name     = data.tfe_outputs.dynamodb.values.images_name
  dynamodb_votes_arn       = data.tfe_outputs.dynamodb.values.votes_owner_arn
  dynamodb_votes_name      = data.tfe_outputs.dynamodb.values.votes_owner_name
  dynamodb_processing_arn  = data.tfe_outputs.dynamodb.values.image_processing_arn
  dynamodb_processing_name = data.tfe_outputs.dynamodb.values.image_processing_name

  api_status_response = {
    "OK"    = { code = "200", pattern = "2\\d{2}" },
    "BAD"   = { code = "400", pattern = "4\\d{2}" },
    "ERROR" = { code = "500", pattern = "5\\d{2}" },
  }
}
