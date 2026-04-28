# aws/base_component/eks

## Purpose
Opinionated EKS module. Managed Kubernetes with enforced secret encryption, private networking, and IAM best practices.

## Usage
```hcl
module "eks" {
  source = "./aws/base_component/eks"

  cluster_name = "my-eks-cluster"
  subnet_ids   = module.vpc.private_subnet_ids
  kms_key_arn  = module.kms.key_arn

  tags = {
    environment = "prod"
    owner       = "platform-team"
    project     = "standardization"
    cost_center = "12345"
  }
}
```

## Security
- **Encryption**: Mandatory CMK encryption for Kubernetes secrets.
- **Network**: Cluster is placed in private VPC subnets. Public access is disabled by default.
- **IAM**: Cluster role is created via the base IAM module with least-privilege permissions.

## Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `cluster_name` | Name of the EKS cluster | `string` | n/a | yes |
| `subnet_ids` | List of subnet IDs for the EKS cluster | `list(string)` | n/a | yes |
| `kms_key_arn` | KMS key ARN for secret encryption | `string` | n/a | yes |
| `kubernetes_version` | Desired Kubernetes master version | `string` | `"1.29"` | no |
| `tags` | Standard tags for all resources | `map(string)` | n/a | yes |

## Outputs
| Name | Description |
|------|-------------|
| `cluster_arn` | The ARN of the EKS cluster |
| `cluster_id` | The name/id of the EKS cluster |
| `cluster_endpoint` | The endpoint for the EKS cluster |
| `cluster_certificate_authority_data` | The base64 encoded certificate data required to communicate with the cluster |
| `cluster_role_arn` | The ARN of the cluster IAM role |
