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
- **Kernel Patching**: To address the "Copy.fail" (CVE-2026-31431) and "Dirty Frag" (CVE-2026-43284/43500) vulnerabilities, all node groups MUST use patched platform versions:
  - EKS Optimized AMI: 20260515 or later
  - Bottlerocket: v1.19.2 or later
  - Dynamic AMI selection via SSM parameters is recommended to ensure rapid patching.

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
| `tags` | A map of tags assigned to the resource |

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of the KMS key for secret encryption | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of subnet IDs where the EKS cluster and nodes will be placed | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | n/a | yes |
| <a name="input_permissions_boundary_arn"></a> [permissions\_boundary\_arn](#input\_permissions\_boundary\_arn) | The ARN of the policy that is used to set the permissions boundary for the role | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | The ARN of the EKS cluster |
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | The base64 encoded certificate data required to communicate with your cluster |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | The endpoint for your EKS Kubernetes API |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The name/id of the EKS cluster |
| <a name="output_cluster_role_arn"></a> [cluster\_role\_arn](#output\_cluster\_role\_arn) | The ARN of the cluster IAM role |
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the resource |

<!-- END_TF_DOCS -->