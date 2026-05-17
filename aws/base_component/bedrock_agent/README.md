# aws/base_component/bedrock_agent

## Purpose
Opinionated Bedrock Agent module. Provides a secure foundation for autonomous systems on AWS with support for instructions, foundation models, and safety guardrails.

## Usage
```hcl
module "bedrock_agent" {
  source = "./aws/base_component/bedrock_agent"

  agent_name              = "my-assistant"
  foundation_model        = "amazon.titan-text-express-v1"
  instruction             = "You are a helpful assistant."
  agent_resource_role_arn = module.iam_role.role_arn
  kms_key_arn             = module.kms.key_arn

  # Optional Guardrail association
  guardrail_identifier = module.guardrail.guardrail_id
  guardrail_version    = module.guardrail.guardrail_version

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}
```

## Security
- **CMK Encryption**: Mandatory customer-managed KMS key for agent encryption.
- **Least Privilege**: IAM roles for agents should follow strict least-privilege principles.
- **Safety**: Support for Bedrock Guardrails to enforce organizational safety filters.
- **Cost Attribution**: Granular cost attribution is supported via tagging. AI spend can be charged back to individual IAM principals, teams, or projects by analyzing tags in usage reports.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `agent_name` | Name of the Bedrock Agent | `string` | n/a | yes |
| `foundation_model` | The foundation model used by the agent | `string` | n/a | yes |
| `instruction` | Instructions that tell the agent what it should do | `string` | n/a | yes |
| `agent_resource_role_arn` | The ARN of the IAM role for the agent | `string` | n/a | yes |
| `kms_key_arn` | The ARN of the KMS key used to encrypt the agent | `string` | n/a | yes |
| `guardrail_identifier` | Unique identifier of the guardrail | `string` | `null` | no |
| `guardrail_version` | Version of the guardrail | `string` | `null` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `agent_id` | The unique identifier of the agent |
| `agent_arn` | The ARN of the agent |
| `agent_alias_id` | The unique identifier of the agent alias |
| `agent_role_arn` | The ARN of the IAM role used by the agent |
| `tags` | A map of tags assigned to the agent |
