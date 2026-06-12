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

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of the KMS key used for encryption at rest. Mandatory per repository standards. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the Bedrock AgentCore Gateway. | `string` | n/a | yes |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | The ARN of the IAM role that the gateway uses to access AWS resources. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources. Required keys: environment, owner, project, cost\_center. | `map(string)` | n/a | yes |
| <a name="input_authorizer_configuration"></a> [authorizer\_configuration](#input\_authorizer\_configuration) | Configuration for request authorization. Required when authorizer\_type is set to CUSTOM\_JWT. | ```object({ custom_jwt_authorizer = object({ discovery_url = string }) })``` | `null` | no |
| <a name="input_authorizer_type"></a> [authorizer\_type](#input\_authorizer\_type) | The type of authorizer for the gateway. Valid values: CUSTOM\_JWT, NONE. | `string` | `"NONE"` | no |
| <a name="input_browsers"></a> [browsers](#input\_browsers) | A map of Bedrock AgentCore Browsers to create. | ```map(object({ description = optional(string) execution_role_arn = string network_configuration = object({ network_mode = string vpc_config = object({ security_groups = list(string) subnets = list(string) }) }) recording = optional(object({ enabled = bool s3_location = object({ bucket = string prefix = optional(string) }) })) }))``` | `{}` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the gateway. | `string` | `null` | no |
| <a name="input_gateway_targets"></a> [gateway\_targets](#input\_gateway\_targets) | A map of Gateway Targets to create for tool orchestration. | ```map(object({ description = optional(string) target_configuration = object({ mcp = object({ lambda = optional(object({ lambda_arn = string })) }) }) }))``` | `{}` | no |
| <a name="input_online_evaluation_configs"></a> [online\_evaluation\_configs](#input\_online\_evaluation\_configs) | A map of Online Evaluation configurations to create. | ```map(object({ description = optional(string) evaluation_execution_role_arn = string enable_on_create = optional(bool, true) data_source_config = object({ cloudwatch_logs = object({ log_group_names = list(string) service_names = list(string) }) }) evaluator_ids = list(string) sampling_percentage = optional(number) }))``` | `{}` | no |
| <a name="input_protocol_configuration"></a> [protocol\_configuration](#input\_protocol\_configuration) | Configuration for the gateway protocol. | ```object({ mcp = object({ instructions = optional(string) search_type = optional(string) supported_versions = optional(list(string)) }) })``` | `null` | no |
| <a name="input_protocol_type"></a> [protocol\_type](#input\_protocol\_type) | The type of protocol for the gateway. Valid values: MCP. | `string` | `"MCP"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_browser_arns"></a> [browser\_arns](#output\_browser\_arns) | A map of Browser ARNs. |
| <a name="output_gateway_arn"></a> [gateway\_arn](#output\_gateway\_arn) | The ARN of the Bedrock AgentCore Gateway. |
| <a name="output_gateway_id"></a> [gateway\_id](#output\_gateway\_id) | The ID of the Bedrock AgentCore Gateway. |
| <a name="output_gateway_target_ids"></a> [gateway\_target\_ids](#output\_gateway\_target\_ids) | A map of Gateway Target IDs. |
| <a name="output_gateway_url"></a> [gateway\_url](#output\_gateway\_url) | The URL of the Bedrock AgentCore Gateway. |
| <a name="output_online_evaluation_config_arns"></a> [online\_evaluation\_config\_arns](#output\_online\_evaluation\_config\_arns) | A map of Online Evaluation configuration ARNs. |
| <a name="output_tags"></a> [tags](#output\_tags) | The tags applied to the resources. |

<!-- END_TF_DOCS -->