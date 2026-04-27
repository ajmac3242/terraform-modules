# <Module Name>

## Purpose
<Describe what this module does and the problem it solves.>

## Usage
```hcl
module "example" {
  source = "../../aws/base_component/<module_name>"

  # Required variables
  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}
```

## Security
- **Encryption**: <Explain CMK usage for data-at-rest.>
- **IAM**: <Describe least-privilege role configuration.>
- **Network**: <Describe VPC placement or public access controls.>

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| tags | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| arn | Primary resource ARN |
| id | Primary resource ID |
