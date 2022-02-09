
locals {
  org = "testigoelectoral"
}


variable "secret_seed" {
  type      = string
  sensitive = true

  validation {
    condition     = length(var.secret_seed) == 32
    error_message = "Secret Seed must be 32 chraracteres length."
  }
}

locals {
  function = {
    hash        = "cognito-user-hash"
    validations = "cognito-validations"
  }
  kms_key_arn      = data.tfe_outputs.kms.values.custom_arn
  kms_key_id       = data.tfe_outputs.kms.values.custom_id
  artifacts_bucket = data.tfe_outputs.s3.values.bucket_artifacts
}

output "hash_arn" {
  value = aws_lambda_alias.hash.arn
}
