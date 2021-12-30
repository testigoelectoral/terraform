
locals {
  api_domain_environment = {
    "prod"  = "api.${local.domain}"
    "dev"   = "api-dev.${local.domain}"
    "stage" = "api-stage.${local.domain}"
  }
  api_domain = local.api_domain_environment[var.environment]
}

resource "aws_acm_certificate" "api" {
  domain_name       = local.api_domain
  validation_method = "DNS"

  tags = {
    environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}

# This is a DNS record for the ACM certificate validation to prove we own the domain
resource "aws_route53_record" "api_validation" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.api.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.api.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.api.domain_validation_options)[0].resource_record_type
  zone_id         = data.aws_route53_zone.zone.id
  ttl             = 60
}

# This tells terraform to cause the route53 validation to happen
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.api.arn
  validation_record_fqdns = [aws_route53_record.api_validation.fqdn]
}

output "arn_api" {
  value = aws_acm_certificate.api.id
}

output "domain_api" {
  value = local.api_domain
}
