# Bedrock AgentCore Module

## Purpose
This module provisions an AWS Bedrock AgentCore Gateway, which enables developers to convert APIs, Lambda functions, and existing services into Model Context Protocol (MCP)-compatible tools for autonomous agent orchestration.

## Usage
```hcl
module "bedrock_agent_core" {
  source = "../../base_component/bedrock_agent_core"

  name        = "my-gateway"
  role_arn    = "arn:aws:iam::123456789012:role/bedrock-gateway-role"
  kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/my-key-id"

  description = "Example AgentCore Gateway"

  tags = {
    environment = "dev"
    owner       = "platform-team"
    project     = "genai-agents"
    cost_center = "12345"
  }
}
```

## Security
- **CMK Encryption**: Mandatory encryption at rest using a Customer Managed Key (CMK) via the `kms_key_arn` variable.
- **IAM Least Privilege**: Ensure the role provided via `role_arn` follows the principle of least privilege.
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
| tags | A map of tags to assign to the resources. Required keys: environment, owner, project, cost_center. | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| gateway_arn | The ARN of the Bedrock AgentCore Gateway. |
| gateway_id | The ID of the Bedrock AgentCore Gateway. |
| gateway_url | The URL of the Bedrock AgentCore Gateway. |
| tags | The tags applied to the gateway. |
