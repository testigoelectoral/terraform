
locals {
  function = "upload"
  org      = "testigoelectoral"
  domain   = "testigoelectoral.org"
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
