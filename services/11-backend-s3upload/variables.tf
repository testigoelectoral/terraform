
locals {
  org = "testigoelectoral"
}

locals {
  function          = "s3-images-uploaded"
  images_bucket     = data.tfe_outputs.s3.values.bucket_images
  images_bucket_arn = data.tfe_outputs.s3.values.arn_images
  artifacts_bucket  = data.tfe_outputs.s3.values.bucket_artifacts
  cognito_arn       = data.tfe_outputs.cognito.values.pool_arn
  cognito_pool_id   = data.tfe_outputs.cognito.values.pool_id
  images_table_arn  = data.tfe_outputs.dynamodb.values.images_arn
  images_table_name = data.tfe_outputs.dynamodb.values.images_name
}
