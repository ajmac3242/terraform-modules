# Bedrock Guardrail Module

## Purpose
This module provides an opinionated implementation for Amazon Bedrock Guardrails. Guardrails provide a critical safety layer for LLM applications, filtering harmful content, blocking topics, and masking PII.

## Usage
```hcl
module "bedrock_guardrail" {
  source = "./aws/base_component/bedrock_guardrail"

  name                      = "org-safety-baseline"
  description               = "Standard safety filters for all agents"
  blocked_input_messaging   = "I cannot process this request due to safety policies."
  blocked_outputs_messaging = "The response was filtered due to safety policies."
  kms_key_arn               = "arn:aws:kms:us-east-1:123456789012:key/..."

  content_policy_config = {
    filters_config = [
      {
        type            = "HATE"
        input_strength  = "HIGH"
        output_strength = "HIGH"
      }
    ]
  }

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "genai-safety"
    cost_center = "12345"
  }
}
```

## Security
- **CMK Encryption**: Mandatory customer-managed KMS key for guardrail encryption.
- **Tagging**: Enforces standard organizational tagging for cost attribution and governance.
- **Immutable Versions**: Automatically creates a version to enable immutable safety baselines.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the Bedrock Guardrail | string | n/a | yes |
| description | Description of the Bedrock Guardrail | string | `null` | no |
| blocked_input_messaging | Messaging for when input is blocked | string | n/a | yes |
| blocked_outputs_messaging | Messaging for when output is blocked | string | n/a | yes |
| kms_key_arn | The ARN of the KMS key used to encrypt the guardrail | string | n/a | yes |
| content_policy_config | Configuration for content policy | object | `null` | no |
| topic_policy_config | Configuration for topic policy | object | `null` | no |
| word_policy_config | Configuration for word policy | object | `null` | no |
| sensitive_information_policy_config | Configuration for sensitive information policy | object | `null` | no |
| contextual_grounding_policy_config | Configuration for contextual grounding policy | object | `null` | no |
| tags | A map of tags to assign to the resources | map(string) | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| guardrail_id | The unique identifier of the guardrail |
| guardrail_arn | The ARN of the guardrail |
| guardrail_version | The version of the guardrail |
| tags | A map of tags assigned to the guardrail |
