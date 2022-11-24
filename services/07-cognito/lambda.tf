
# resource "aws_lambda_permission" "lambda_policy" {
#   statement_id  = "AllowExecutionFromCognito"
#   action        = "lambda:InvokeFunction"
#   principal     = "cognito-idp.amazonaws.com"
#   source_arn    = aws_cognito_user_pool.account.arn
#   function_name = "backend-cognito-user-hash-${var.environment}"
#   qualifier     = "running"
# }

# resource "aws_iam_policy" "policy" {
#   name = "lambda-cognito-user-hash-${var.environment}"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect   = "Allow"
#         Action   = "cognito-idp:AdminUpdateUserAttributes"
#         Resource = "${aws_cognito_user_pool.account.arn}"
#       },
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "policy-attach" {
#   role       = "lambda-cognito-user-hash-${var.environment}"
#   policy_arn = aws_iam_policy.policy.arn
# }
