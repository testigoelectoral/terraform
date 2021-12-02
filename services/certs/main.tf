
resource "aws_acm_certificate" "api" {
  domain_name       = local.api_domain
  validation_method = "DNS"

  tags = {
    environment = local.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}
