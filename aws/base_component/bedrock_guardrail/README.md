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

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_blocked_input_messaging"></a> [blocked\_input\_messaging](#input\_blocked\_input\_messaging) | The message to return when input is blocked | `string` | n/a | yes |
| <a name="input_blocked_outputs_messaging"></a> [blocked\_outputs\_messaging](#input\_blocked\_outputs\_messaging) | The message to return when output is blocked | `string` | n/a | yes |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of the KMS key for encryption | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the guardrail | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | n/a | yes |
| <a name="input_content_policy_config"></a> [content\_policy\_config](#input\_content\_policy\_config) | Content policy config for a guardrail | ```list(object({ filters_config = list(object({ type = string input_strength = string output_strength = string })) }))``` | `[]` | no |
| <a name="input_contextual_grounding_policy_config"></a> [contextual\_grounding\_policy\_config](#input\_contextual\_grounding\_policy\_config) | Contextual grounding policy config for a guardrail | ```list(object({ filters_config = list(object({ type = string threshold = number })) }))``` | `[]` | no |
| <a name="input_description"></a> [description](#input\_description) | A description of the guardrail | `string` | `null` | no |
| <a name="input_sensitive_information_policy_config"></a> [sensitive\_information\_policy\_config](#input\_sensitive\_information\_policy\_config) | Sensitive information policy config for a guardrail | ```list(object({ pii_entities_config = optional(list(object({ type = string action = string }))) regexes_config = optional(list(object({ name = string description = optional(string) pattern = string action = string }))) }))``` | `[]` | no |
| <a name="input_topic_policy_config"></a> [topic\_policy\_config](#input\_topic\_policy\_config) | Topic policy config for a guardrail | ```list(object({ topics_config = list(object({ name = string definition = string examples = optional(list(string)) type = string })) }))``` | `[]` | no |
| <a name="input_word_policy_config"></a> [word\_policy\_config](#input\_word\_policy\_config) | Word policy config for a guardrail | ```list(object({ managed_word_lists_config = optional(list(object({ type = string }))) words_config = optional(list(object({ text = string }))) }))``` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_guardrail_arn"></a> [guardrail\_arn](#output\_guardrail\_arn) | The ARN of the guardrail |
| <a name="output_guardrail_id"></a> [guardrail\_id](#output\_guardrail\_id) | The unique identifier of the guardrail |
| <a name="output_guardrail_version"></a> [guardrail\_version](#output\_guardrail\_version) | The version of the guardrail |
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the resource |

<!-- END_TF_DOCS -->