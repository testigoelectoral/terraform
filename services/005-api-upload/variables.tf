
locals {
  function = "upload"
  org      = "testigoelectoral"
  domain   = "testigoelectoral.org"
}

data "tfe_outputs" "s3" {
  organization = local.org
  workspace    = "${var.environment}-004-s3"
}

data "tfe_outputs" "apigw" {
  organization = local.org
  workspace    = "${var.environment}-002-api-gateway"
}

data "tfe_outputs" "cognito" {
  organization = local.org
  workspace    = "${var.environment}-003-cognito"
}

locals {
  artifacts_bucket     = data.tfe_outputs.s3.values.bucket_artifacts
  artifacts_bucket_arn = data.tfe_outputs.s3.values.arn_artifacts
  images_bucket        = data.tfe_outputs.s3.values.bucket_images
  images_bucket_arn    = data.tfe_outputs.s3.values.arn_images
  apigw_id             = data.tfe_outputs.apigw.values.arn_api
  apigw_root           = data.tfe_outputs.apigw.values.root_id
  cognito_autorizer    = data.tfe_outputs.cognito.values.authorizer_id
  api_status_response  = ["200", "500"]
}
