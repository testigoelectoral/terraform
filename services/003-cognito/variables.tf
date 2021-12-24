
output "pool_id" {
    value = aws_cognito_user_pool.testigo.id
}

output "pool_arn" {
    value = aws_cognito_user_pool.testigo.arn
}

output "pool_endpoint" {
    value = aws_cognito_user_pool.testigo.endpoint
}

output "client_id" {
    value = aws_cognito_user_pool_client.testigo.id
}
