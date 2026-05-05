# Centralized Logging

## Purpose
This workload component provides a secure, centralized logging foundation using S3 for storage and Athena for analysis. It is designed to aggregate logs from various AWS services including ALB, CloudFront, and VPC Flow Logs, enforcing CMK encryption and SSL-only access.

## Usage
```hcl
module "centralized_logging" {
  source = "./aws/workload_component/centralized_logging"

  name_prefix    = "org-logs"
  aws_account_id = "123456789012"
  alb_account_id = "127311923021" # us-east-1 ELB account ID

  tags = {
    environment = "prod"
    owner       = "security-team"
    project     = "compliance"
    cost_center = "ops-123"
  }
}
```

## Security
- **CMK Encryption**: All logs are encrypted at rest using a customer-managed KMS key.
- **SSL Only**: S3 bucket policies enforce SSL-only access to log data.
- **Public Access Blocked**: All public access to the log bucket is explicitly blocked.
- **Least Privilege**: Bucket policies are scoped to specific service principals (ALB, CloudFront OAC, VPC Flow Logs).

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name_prefix | Prefix to use for all resources created by this module | `string` | n/a | yes |
| tags | A map of tags to assign to the resources | `map(string)` | n/a | yes |
| aws_account_id | The AWS account ID for resource policies | `string` | n/a | yes |
| alb_account_id | The AWS account ID for the ELB service principal in the current region | `string` | n/a | yes |
| vpc_flow_logs_service_principal | The service principal for VPC Flow Logs | `string` | `delivery.logs.amazonaws.com` | no |

## Outputs
| Name | Description |
|------|-------------|
| log_bucket_id | The ID of the centralized log bucket |
| log_bucket_arn | The ARN of the centralized log bucket |
| kms_key_arn | The ARN of the KMS key used for log encryption |
| athena_workgroup_name | The name of the Athena workgroup |
