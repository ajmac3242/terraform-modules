# aws/base_component/eks

Opinionated EKS cluster module. Enforces VPC placement, mandatory IAM role (managed), and secret encryption (CMK).

## Features

- Managed EKS cluster
- Mandatory secret encryption using CMK
- Cluster role created via `aws/base_component/iam`
- Required tags enforced

## Usage

```hcl
module "eks" {
  source = "./aws/base_component/eks"

  cluster_name = "my-cluster-prod"
  subnet_ids   = module.vpc.private_subnet_ids
  kms_key_arn  = module.kms.key_arn

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "my-app"
    cost_center = "CC-1234"
  }
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| `cluster_name` | Name of the cluster | `string` | yes |
| `subnet_ids` | VPC subnets | `list(string)` | yes |
| `kms_key_arn` | ARN of KMS key for secrets | `string` | yes |
| `tags` | Map of tags | `map(string)` | yes |

## Outputs

| Name | Description |
|------|-------------|
| `cluster_arn` | The ARN of the cluster |
| `cluster_endpoint` | API server endpoint |
| `cluster_certificate_authority_data` | CA data |
