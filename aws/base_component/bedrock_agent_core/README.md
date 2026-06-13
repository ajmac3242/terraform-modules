# Bedrock AgentCore Module

## Purpose
This module provisions an AWS Bedrock AgentCore Gateway along with supporting resources for Online Evaluation, Browser tools, and Gateway Targets. It enables developers to convert APIs, Lambda functions, and services into Model Context Protocol (MCP)-compatible tools, while providing continuous performance monitoring and browser-based task capabilities.

> [!IMPORTANT]
> **Provider Requirement:** This module requires AWS Provider `v6.47.0` or later to support Online Evaluation and Browser tool resources.

## Usage
```hcl
module "bedrock_agent_core" {
  source = "../../base_component/bedrock_agent_core"

  name        = "my-gateway"
  role_arn    = "arn:aws:iam::123456789012:role/bedrock-gateway-role"
  kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/my-key-id"

  description = "Example AgentCore Gateway with Browser and Evaluation"

  # Browser tool configuration
  browsers = {
    "default-browser" = {
      execution_role_arn = "arn:aws:iam::123456789012:role/browser-execution-role"
      network_configuration = {
        network_mode = "VPC"
        vpc_config = {
          security_groups = ["sg-12345678"]
          subnets         = ["subnet-12345678"]
        }
      }
      recording = {
        enabled = true
        s3_location = {
          bucket = "my-browser-recordings"
        }
      }
    }
  }

  # Online Evaluation configuration
  online_evaluation_configs = {
    "continous-eval" = {
      evaluation_execution_role_arn = "arn:aws:iam::123456789012:role/eval-execution-role"
      data_source_config = {
        cloudwatch_logs = {
          log_group_names = ["/aws/vendedlogs/bedrock-agent-logs"]
          service_names   = ["bedrock"]
        }
      }
      evaluator_ids       = ["arn:aws:bedrock:us-east-1::evaluator/bert-score"]
      sampling_percentage = 10.0
    }
  }

  tags = {
    environment = "dev"
    owner       = "platform-team"
    project     = "genai-agents"
    cost_center = "12345"
  }
}
```

## Security
- **CMK Encryption**: Mandatory encryption at rest using a Customer Managed Key (CMK) via the `kms_key_arn` variable. Browser recordings (S3) and Evaluation logs (CloudWatch) must also be CMK-encrypted.
- **Secure Gateway Targets**: Supports advanced credential providers including JWT passthrough, Caller IAM credentials, and Gateway IAM roles for secure tool orchestration.
- **VPC Sandboxing**: Browser tools are placed within a VPC with configurable security groups and subnets to ensure network isolation.
- **IAM Least Privilege**: Ensure all provided execution roles follow the principle of least privilege.
- **Tagging**: Enforces organizational tagging standards for cost attribution and governance.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the Bedrock AgentCore Gateway. | `string` | n/a | yes |
| role_arn | The ARN of the IAM role that the gateway uses to access AWS resources. | `string` | n/a | yes |
| kms_key_arn | The ARN of the KMS key used for encryption at rest. | `string` | n/a | yes |
| description | Description of the gateway. | `string` | `null` | no |
| authorizer_type | The type of authorizer for the gateway. Valid values: CUSTOM_JWT, NONE. | `string` | `"NONE"` | no |
| authorizer_configuration | Configuration for request authorization. Required when authorizer_type is set to CUSTOM_JWT. | `object` | `null` | no |
| protocol_type | The type of protocol for the gateway. Valid values: MCP. | `string` | `"MCP"` | no |
| protocol_configuration | Configuration for the gateway protocol. | `object` | `null` | no |
| online_evaluation_configs | A map of Online Evaluation configurations to create. | `map(object)` | `{}` | no |
| browsers | A map of Bedrock AgentCore Browsers to create. | `map(object)` | `{}` | no |
| gateway_targets | A map of Gateway Targets to create for tool orchestration. | `map(object)` | `{}` | no |
| tags | A map of tags to assign to the resources. Required keys: environment, owner, project, cost_center. | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| gateway_arn | The ARN of the Bedrock AgentCore Gateway. |
| gateway_id | The ID of the Bedrock AgentCore Gateway. |
| gateway_url | The URL of the Bedrock AgentCore Gateway. |
| online_evaluation_config_arns | A map of Online Evaluation configuration ARNs. |
| browser_arns | A map of Browser ARNs. |
| gateway_target_ids | A map of Gateway Target IDs. |
| tags | The tags applied to the resources. |
