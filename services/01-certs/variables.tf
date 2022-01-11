
locals {
  domain = "testigoelectoral.org"
}

# This data source looks up the public DNS zone
data "aws_route53_zone" "zone" {
  name         = local.domain
  private_zone = false
}
