
locals {
  app_domain_environment = {
    "prod"  = "app.${local.domain}"
    "dev"   = "app-dev.${local.domain}"
    "stage" = "app-stage.${local.domain}"
  }
  app_domain = local.app_domain_environment[var.environment]
}

resource "aws_acm_certificate" "app" {
  domain_name       = local.app_domain
  validation_method = "DNS"
  provider          = aws.virginia

  tags = {
    environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}

# This is a DNS record for the ACM certificate validation to prove we own the domain
resource "aws_route53_record" "app_validation" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.app.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.app.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.app.domain_validation_options)[0].resource_record_type
  zone_id         = data.aws_route53_zone.zone.id
  ttl             = 60
}

# This tells terraform to cause the route53 validation to happen
resource "aws_acm_certificate_validation" "cert_app" {
  certificate_arn         = aws_acm_certificate.app.arn
  validation_record_fqdns = [aws_route53_record.app_validation.fqdn]
  provider                = aws.virginia
}

output "arn_app" {
  value = aws_acm_certificate.app.id
}

output "domain_app" {
  value = local.app_domain
}
