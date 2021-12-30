
locals {
  cognito_domain_environment = {
    "prod"  = "user.${local.domain}"
    "dev"   = "user-dev.${local.domain}"
    "stage" = "user-stage.${local.domain}"
  }
  cognito_domain = local.cognito_domain_environment[var.environment]
}

resource "aws_acm_certificate" "cognito" {
  domain_name       = local.cognito_domain
  validation_method = "DNS"

  tags = {
    environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}

# This is a DNS record for the ACM certificate validation to prove we own the domain
resource "aws_route53_record" "cognito_validation" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.cognito.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.cognito.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.cognito.domain_validation_options)[0].resource_record_type
  zone_id         = data.aws_route53_zone.zone.id
  ttl             = 60
}

# This tells terraform to cause the route53 validation to happen
resource "aws_acm_certificate_validation" "cert_cognito" {
  certificate_arn         = aws_acm_certificate.cognito.arn
  validation_record_fqdns = [aws_route53_record.cognito_validation.fqdn]
}

output "arn_cognito" {
  value = aws_acm_certificate.cognito.id
}

output "domain_cognito" {
  value = local.cognito_domain
}
