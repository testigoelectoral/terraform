resource "aws_iam_role" "login" {
  name               = "apigw-login-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.login-assume.json
}

data "aws_iam_policy_document" "login-assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "login" {
  name = "apigw-login-${var.environment}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cognito-idp:InitiateAuth",
          "cognito-idp:SignUp",
          "cognito-idp:ConfirmSignUp",
          "cognito-idp:ResendConfirmationCode",
          "cognito-idp:ChangePassword",
          "cognito-idp:ForgotPassword",
          "cognito-idp:ConfirmForgotPassword"
        ]
        Resource = "${local.pool_arn}"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach-login" {
  role       = aws_iam_role.login.name
  policy_arn = aws_iam_policy.login.arn
}
