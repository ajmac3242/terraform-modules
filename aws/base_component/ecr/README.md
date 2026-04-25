# aws/base_component/ecr

Opinionated ECR Repository module.

## Features

- ECR Repository
- Mandatory KMS encryption with CMK (auto-created or provided)
- Mandatory image scanning on push
- IMMUTABLE tags by default
- Configurable lifecycle policy (defaults to keeping 30 images)
- Tags validation

## Usage

```hcl
module "ecr" {
  source = "./aws/base_component/ecr"

  name = "my-repo"

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "my-app"
    cost_center = "CC-1234"
  }
}
```

### With Existing KMS Key and Custom Lifecycle Policy

```hcl
module "ecr" {
  source = "./aws/base_component/ecr"

  name                = "my-repo"
  existing_kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/..."
  lifecycle_policy    = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "my-app"
    cost_center = "CC-1234"
  }
}
```
