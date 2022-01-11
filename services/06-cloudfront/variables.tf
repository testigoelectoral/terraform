
locals {
  org    = "testigoelectoral"
  domain = "testigoelectoral.org"
}

data "aws_route53_zone" "testigo" {
  name         = local.domain
  private_zone = false
}

data "aws_s3_bucket" "app" {
  bucket = local.bucket_name
}

locals {
  app_domain     = data.tfe_outputs.certs.values.domain_app
  app_cert       = data.tfe_outputs.certs.values.arn_app
  bucket_name    = data.tfe_outputs.s3.values.bucket_webapp
  bucket_arn     = data.tfe_outputs.s3.values.arn_webapp
  user_artifacts = data.tfe_outputs.s3.values.user_artifacts
  s3_origin_id   = "${var.environment}-s3webapp"
}
