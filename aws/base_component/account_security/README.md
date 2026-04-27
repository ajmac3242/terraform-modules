# Opinionated Account Security Module

This module enforces account-level and region-level security standards to provide a safe baseline for AWS environments. It handles S3 public access blocking, default security group hardening, and IMDSv2 enforcement for EC2.

## Purpose

While individual resources (like S3 buckets) should have their own security configurations, this module provides an account-wide "safety net" that prevents accidental exposure even if a resource-level setting is misconfigured.

## Features

- **S3 Account-level Public Access Block**: Enforces `block_public_acls`, `block_public_policy`, `ignore_public_acls`, and `restrict_public_buckets` for the entire AWS account.
- **Default Security Group Hardening**: Removes all ingress and egress rules from the `default` security group of a VPC.
- **EC2 Instance Metadata Defaults**: Enforces IMDSv2 (Session Tokens Required) and sets the hop limit to `1` by default to prevent metadata access from within containers.
- **EBS Encryption by Default**: Enforces that all new EBS volumes created in the account/region are encrypted.
- **IAM Account Password Policy**: Enforces strong password requirements for IAM users.
- **IAM Access Analyzer**: Enables continuous monitoring of resource sharing with external entities.

## Usage

```hcl
module "account_security" {
  source = "aws/base_component/account_security"

  vpc_id = "vpc-12345678"

  tags = {
    environment = "prod"
    owner       = "security-team"
    project     = "infrastructure-hardening"
    cost_center = "1234"
  }
}
```

## Security Best Practices Enforced

- **IMDSv2**: Setting `http_tokens = "required"` mitigates SSRF vulnerabilities that target the EC2 metadata service.
- **Hop Limit**: A hop limit of `1` ensures that the metadata service is not accessible from containers running on the instance (which typically require an additional network hop).
- **Default SG**: VPC default security groups are created automatically and often have overly permissive rules. Hardening them ensures they cannot be used for traffic unless explicitly configured otherwise.
- **S3 Public Access**: Account-level blocks provide a final layer of defense against accidental public bucket exposure.
