# Contributing to terraform-modules

Thank you for contributing to our opinionated Terraform module library! To maintain high quality, security, and consistency, all contributions must follow these guidelines.

## Module Structure

Every module must include:
- `main.tf`: Primary resource definitions.
- `variables.tf`: All input variables with descriptions and type constraints.
- `outputs.tf`: All outputs with descriptions.
- `versions.tf`: Provider and Terraform version constraints.
- `README.md`: Documentation following the standard template.
- `tests/main.tftest.hcl`: Native Terraform tests.

## Testing Standard

Native `terraform test` coverage is mandatory for every module.

### Requirements:
1. **File Location**: All tests must reside in the `tests/` directory within the module (e.g., `tests/main.tftest.hcl`).
2. **Offline Execution**: Use mock providers to ensure tests can run without real AWS credentials.
3. **Resource Creation**: Validate that all primary resources are correctly defined in the plan or apply.
4. **Security & Encryption**: Explicitly assert that CMK encryption is enabled for all data-at-rest resources. For resources using `kms_key_arn` or `kms_master_key_id`, verify the value matches the expected input.
5. **Tagging**: Validate that the mandatory tags (`environment`, `owner`, `project`, `cost_center`) are applied to all taggable resources by checking `aws_resource.this.tags`.
6. **Negative Testing**: Where applicable, include tests that assert failure for invalid configurations using `expect_failures`.

### Mock Provider Example:
```hcl
provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
}
```

## README Standard

All modules must follow the template defined in `DOCS_TEMPLATE.md`. The following sections must appear in order:
1. **Purpose**: Clear description of what the module does and why.
2. **Usage**: A valid HCL code snippet demonstrating common usage.
3. **Security**: Details on security defaults (encryption, IAM, etc.).
4. **Variables**: Table of all input variables.
5. **Outputs**: Table of all output values.

## Security-by-Default

- Use Customer Managed Keys (CMK) for all encryption.
- Enforce least-privilege for all IAM roles.
- No public access for any resource unless explicitly justified.
- Enable logging and tracing (X-Ray) where supported.
