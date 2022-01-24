
locals {
  org    = "testigoelectoral"
  domain = "testigoelectoral.org"
}

locals {
  images_bucket     = data.tfe_outputs.s3.values.bucket_images
  images_bucket_arn = data.tfe_outputs.s3.values.arn_images
  apigw_id          = data.tfe_outputs.apigw.values.arn_api
  apigw_root        = data.tfe_outputs.apigw.values.root_id
  cognito_autorizer = data.tfe_outputs.cognito.values.authorizer_id
  api_status_response = {
    "OK"    = { code = "200", pattern = "2\\d{2}" },
    "BAD"   = { code = "400", pattern = "4\\d{2}" },
    "ERROR" = { code = "500", pattern = "5\\d{2}" },
  }
}