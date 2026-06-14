# Bedrock AgentCore Module

## Purpose
This module provisions an AWS Bedrock AgentCore Gateway along with supporting resources for Online Evaluation, Browser tools, and Gateway Targets. It enables developers to convert APIs, Lambda functions, and services into Model Context Protocol (MCP)-compatible tools, while providing continuous performance monitoring and browser-based task capabilities.

> [!IMPORTANT]
> **Provider Requirement:** This module requires AWS Provider `v6.49.0` or later to support enhanced Gateway protocol configurations (streaming, sessions) and expanded target credential providers.

## Usage
```hcl
module "bedrock_agent_core" {
  source = "../../base_component/bedrock_agent_core"

  name        = "my-gateway"
  role_arn    = "arn:aws:iam::123456789012:role/bedrock-gateway-role"
  kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/my-key-id"

  description = "Example AgentCore Gateway with MCP enhancements and Targets"

  # Protocol configuration with session and streaming
  protocol_configuration = {
    mcp = {
      instructions = "You are a helpful research assistant."
      session_configuration = {
        session_timeout_in_seconds = 3600
      }
      streaming_configuration = {
        enable_response_streaming = true
      }
    }
  }

  # Gateway Targets with enhanced credential providers
  gateway_targets = {
    "lambda-target" = {
      description = "Target routing to a Lambda function via MCP"
      target_configuration = {
        mcp = {
          lambda = {
            lambda_arn = "arn:aws:lambda:us-east-1:123456789012:function:my-tool"
          }
        }
      }
    }
    "enhanced-http-target" = {
      description = "Target using JWT passthrough to an HTTP runtime"
      target_configuration = {
        http = {
          agentcore_runtime = {
            arn = "arn:aws:bedrock:us-east-1:123456789012:agent-runtime/my-app"
          }
        }
      }
      credential_provider_configuration = {
        jwt_passthrough = true
      }
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
| protocol_configuration | Configuration for the gateway protocol. Includes `mcp` with `session_configuration` and `streaming_configuration`. | `object` | `null` | no |
| online_evaluation_configs | A map of Online Evaluation configurations to create. Key is the evaluation config name. | `map(object)` | `{}` | no |
| browsers | A map of Bedrock AgentCore Browsers to create. Key is the browser name. | `map(object)` | `{}` | no |
| gateway_targets | A map of Gateway Targets to create for tool orchestration. Supports `http` and `mcp` targets with advanced credentials. | `map(object)` | `{}` | no |
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
