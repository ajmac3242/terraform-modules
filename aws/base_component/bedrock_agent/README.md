# aws/base_component/bedrock_agent

## Purpose
Opinionated Bedrock Agent module. Provides a secure foundation for autonomous systems on AWS, responding to trends in Agentic AI.

## Usage
```hcl
module "bedrock_agent" {
  source = "./aws/base_component/bedrock_agent"

  agent_name              = "my-ai-assistant"
  foundation_model        = "anthropic.claude-3-sonnet-20240229-v1:0"
  instruction             = "You are a helpful assistant."
  agent_resource_role_arn = "arn:aws:iam::123456789012:role/my-agent-role"

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}
```

## Security
- **Encryption**: Mandatory CMK encryption for any associated data stores or customer-managed resources.
- **IAM**: Execution roles follow strict least-privilege principles (no `*` actions).
- **Control**: Access is controlled via resource-based and identity-based policies.
- **Cost Attribution**: Granular cost attribution is supported via tagging. AI spend can be charged back to individual IAM principals, teams, or projects by analyzing tags in usage reports.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `agent_name` | Name of the Bedrock Agent | `string` | n/a | yes |
| `foundation_model` | The foundation model used by the agent | `string` | n/a | yes |
| `instruction` | Instructions for the agent | `string` | n/a | yes |
| `agent_resource_role_arn` | The ARN of the IAM role with permissions to invoke the agent | `string` | n/a | yes |
| `kms_key_arn` | KMS key ARN for encryption | `string` | n/a | yes |
| `guardrail_configuration` | Guardrail configuration for the agent | `object` | `null` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `agent_id` | The unique identifier of the agent |
| `agent_arn` | The ARN of the agent |
| `agent_alias_id` | The unique identifier of the agent alias |
| `agent_role_arn` | The ARN of the IAM role used by the agent |
| `tags` | A map of tags assigned to the agent |
