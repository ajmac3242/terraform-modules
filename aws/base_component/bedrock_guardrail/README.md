# Bedrock Guardrail Module

## Purpose
Standardizes the creation of Amazon Bedrock Guardrails to provide a safety layer for LLM applications. It filters harmful content, blocks topics, masks PII, and detects hallucinations.

## Usage
```hcl
module "guardrail" {
  source = "./aws/base_component/bedrock_guardrail"

  name                      = "corporate-safety-baseline"
  blocked_input_messaging   = "I cannot answer this due to safety policies."
  blocked_outputs_messaging = "The response was blocked due to safety policies."
  kms_key_arn               = "arn:aws:kms:us-east-1:123456789012:key/..."

  content_policy_config = [{
    filters_config = [
      {
        type            = "HATE"
        input_strength  = "HIGH"
        output_strength = "HIGH"
      }
    ]
  }]

  tags = {
    environment = "prod"
    owner       = "security-team"
    project     = "genai-safety"
    cost_center = "1234"
  }
}
```

## Security
- Mandatory CMK encryption for data at rest.
- Enforces strict safety filters for LLM interactions.
- PII masking and sensitive word filtering.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the guardrail | string | n/a | yes |
| blocked_input_messaging | Message when input is blocked | string | n/a | yes |
| blocked_outputs_messaging | Message when output is blocked | string | n/a | yes |
| kms_key_arn | ARN of the KMS key for encryption | string | n/a | yes |
| content_policy_config | Content filter settings | list | [] | no |
| topic_policy_config | Denied topics settings | list | [] | no |
| word_policy_config | Word filter settings | list | [] | no |
| sensitive_information_policy_config | PII and regex filters | list | [] | no |
| contextual_grounding_policy_config | Hallucination filters | list | [] | no |
| tags | Resource tags | map(string) | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| guardrail_id | Unique ID of the guardrail |
| guardrail_arn | ARN of the guardrail |
| guardrail_version | Current version of the guardrail |
| tags | Tags assigned to the resource |
