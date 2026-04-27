# aws_cognito_user_pool
resource "aws_cognito_user_pool" "this" {
  name = var.user_pool_name

  # Advanced security mode
  user_pool_add_ons {
    advanced_security_mode = var.advanced_security_mode
  }

  password_policy {
    minimum_length    = 12
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  tags = var.tags
}

# aws_cognito_user_pool_client
resource "aws_cognito_user_pool_client" "this" {
  name         = var.client_name
  user_pool_id = aws_cognito_user_pool.this.id

  # Secure defaults
  generate_secret     = false
  explicit_auth_flows = ["ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH"]
}
