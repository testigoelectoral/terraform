
locals {
  org    = "testigoelectoral"
  domain = "testigoelectoral.org"
}

data "tfe_outputs" "certs" {
  organization = local.org
  workspace    = "${var.environment}-001-certs"
}

data "tfe_outputs" "s3" {
  organization = local.org
  workspace    = "${var.environment}-004-s3"
}

data "aws_route53_zone" "testigo" {
  name         = local.domain
  private_zone = false
}

data "aws_s3_bucket" "app" {
  bucket = local.bucket_name
}

locals {
  app_domain   = data.tfe_outputs.certs.values.domain_app
  app_cert     = data.tfe_outputs.certs.values.arn_app
  bucket_name  = data.tfe_outputs.s3.values.bucket_webapp
  bucket_arn   = data.tfe_outputs.s3.values.arn_webapp
  s3_origin_id = "${var.environment}-s3webapp"
}
