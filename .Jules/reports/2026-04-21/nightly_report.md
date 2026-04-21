# Sentinel Nightly Report — 2026-04-21

## Modules Scanned
- 19 base modules (iam, kms, s3, lambda, vpc, dynamodb, rds, sqs, ssm, ecs_fargate, cloudfront, vpc_endpoints, subnet, security_group, sns, secrets_manager, route53, elasticache, eks)
- 1 workload component (apigw_lambda)

## Violations Found
- **CRITICAL**: 0
- **HIGH**: 3 (S3 logging disabled by default, APIGW Lambda missing JWT, APIGW Lambda missing WAF)
- **MEDIUM**: 0
- **LOW**: 1 (Lambda reserved concurrency documentation)

## PRs Opened
- `fix(sentinel): enforce S3 access logging and improve Lambda docs`
  - Sets `enable_access_logging = true` by default in S3 module.
  - Updates `reserved_concurrent_executions` description in Lambda module.

## Issues Filed (Content)
### Issue 1: [security] [sentinel] [aws-apigateway] — APIGW Lambda missing mandatory JWT Authorizer
**Description**: The `apigw_lambda` workload component does not implement JWT authorization by default.
**Standard**: "JWT authorizer required for any non-public route — make this the default"
**Remediation**: Add `aws_apigatewayv2_authorizer` resource and associate it with the route.
\`\`\`hcl
resource "aws_apigatewayv2_authorizer" "this" {
  api_id           = aws_apigatewayv2_api.this.id
  authorizer_type  = "JWT"
  identity_sources = ["\$request.header.Authorization"]
  name             = "jwt-authorizer"

  jwt_configuration {
    audience = var.jwt_audience
    issuer   = var.jwt_issuer
  }
}
\`\`\`

### Issue 2: [security] [sentinel] [aws-apigateway] — APIGW Lambda missing mandatory WAF association
**Description**: The `apigw_lambda` workload component is missing WAF association.
**Standard**: "Mandatory WAF association" (for CloudFront, and implied for public endpoints).
**Remediation**: Add `aws_wafv2_web_acl_association` for the API Gateway stage.
\`\`\`hcl
resource "aws_wafv2_web_acl_association" "this" {
  resource_arn = aws_apigatewayv2_stage.this.arn
  web_acl_arn  = var.waf_web_acl_arn
}
\`\`\`

## Modules Passed
- All other 18 modules passed the baseline security audit.
