# aws/base_component/bedrock_agent

## Purpose
Opinionated Bedrock Agent module. Provides a secure foundation for autonomous systems on AWS, enforcing CMK encryption and least-privilege IAM patterns.

## Usage
```hcl
module "bedrock_agent" {
  source = "./aws/base_component/bedrock_agent"

  agent_name              = "my-assistant"
  foundation_model        = "anthropic.claude-3-sonnet-20240229-v1:0"
  instruction             = "You are a helpful assistant."
  agent_resource_role_arn = "arn:aws:iam::123456789012:role/my-agent-role"
  customer_encryption_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  tags = {
    environment = "prod"
    owner       = "ai-team"
    project     = "internal-tools"
    cost_center = "CC-5678"
  }
}
```

## Security
- **Encryption**: Mandatory CMK encryption for the agent using `customer_encryption_key_arn`.
- **IAM**: Requires a pre-defined least-privilege IAM role for the agent.
- **Observability**: Supports tagging for cost allocation and governance.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `agent_name` | Name of the Bedrock Agent | `string` | n/a | yes |
| `foundation_model` | The foundation model used by the agent | `string` | n/a | yes |
| `instruction` | Instructions for the agent | `string` | n/a | yes |
| `agent_resource_role_arn` | ARN of the IAM role for the agent | `string` | n/a | yes |
| `customer_encryption_key_arn` | ARN of the KMS key for encryption | `string` | n/a | yes |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `agent_id` | The unique identifier of the agent |
| `agent_arn` | The ARN of the agent |
| `agent_alias_id` | The unique identifier of the agent alias |
