# Multicloud Hub Workload Module

## Purpose

This module implements the Enterprise Multicloud Networking pattern. It composes the `aws_interconnect` base module with a Transit Gateway to provide a standardized regional hub for cross-cloud connectivity (OCI, Azure). It enforces MACsec encryption, enables BGP route propagation, and includes security monitoring via Transit Gateway Flow Logs.

## Usage

```hcl
module "multicloud_hub" {
  source = "./aws/workload_component/multicloud_hub"

  name           = "hub-oci-us-east-1"
  cloud_provider = "OCI"
  bandwidth      = "1Gbps"
  location       = "EqDC2"
  vlan           = 100
  kms_key_arn    = "arn:aws:kms:us-east-1:123456789012:key/mrk-1234abcd"

  tags = {
    environment = "prod"
    owner       = "network-team"
    project     = "multicloud-mesh"
    cost_center = "99999"
  }
}
```

## Security

- **Encryption**: Enforces MACsec encryption at the Direct Connect connection layer via the `aws_interconnect` base module.
- **Monitoring**: Provision Transit Gateway Flow Logs sent to a CMK-encrypted CloudWatch Log Group for traffic visibility and audit.
- **Isolation**: Uses a dedicated Direct Connect Gateway and Transit Gateway to isolate multicloud traffic from other network paths.

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the Multicloud Hub | `string` | n/a | yes |
| cloud_provider | The cloud provider to interconnect with (OCI, AZURE) | `string` | n/a | yes |
| bandwidth | The bandwidth of the interconnect connection (1Gbps, 10Gbps) | `string` | `"1Gbps"` | no |
| location | The Direct Connect location for the connection | `string` | n/a | yes |
| amazon_side_asn | The ASN for the Amazon side of the gateway | `string` | `"64512"` | no |
| vlan | The VLAN ID for the virtual interface | `number` | n/a | yes |
| customer_bgp_asn | The BGP ASN for the customer side | `number` | `65000` | no |
| kms_key_arn | The ARN of the KMS key for CloudWatch Log Group encryption | `string` | n/a | yes |
| tags | A map of tags to assign to the resources | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| tgw_id | The ID of the Transit Gateway |
| dx_gateway_id | The ID of the Direct Connect Gateway |
| hub_arn | The ARN of the Transit Gateway |
| interconnect_connection_id | The ID of the Direct Connect connection |
| vif_id | The ID of the Transit Virtual Interface |
| tgw_log_role_arn | The ARN of the IAM role used for Transit Gateway Flow Logs |
| tags | A map of tags assigned to the resources |
