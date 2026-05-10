# AWS Interconnect Base Module

## Purpose

This module provisions opinionated AWS Interconnect resources for managed Layer 3 private connectivity between AWS and other cloud providers (OCI, Azure). It standardizes the setup of Direct Connect Gateways and connections with enforced encryption and tagging.

## Usage

```hcl
module "interconnect_oci" {
  source = "./aws/base_component/aws_interconnect"

  name           = "oci-link"
  cloud_provider = "OCI"
  bandwidth      = "1Gbps"
  location       = "EqDC2"
  vlan           = 100

  tags = {
    environment = "prod"
    owner       = "network-team"
    project     = "multicloud-mesh"
    cost_center = "99999"
  }
}
```

## Security

- **Encryption**: Enforces MACsec encryption for transit data to ensure secure multicloud communication.
- **Dedicated Gateway**: Uses a dedicated Direct Connect Gateway for clean L3 routing isolation.

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the Interconnect gateway | `string` | n/a | yes |
| cloud_provider | The cloud provider to interconnect with (OCI, AZURE) | `string` | n/a | yes |
| bandwidth | The bandwidth of the interconnect connection (1Gbps, 10Gbps) | `string` | `"1Gbps"` | no |
| location | The Direct Connect location for the connection | `string` | n/a | yes |
| amazon_side_asn | The ASN for the Amazon side of the gateway | `string` | `"64512"` | no |
| vlan | The VLAN ID for the virtual interface | `number` | n/a | yes |
| vif_type | The type of virtual interface to create (PRIVATE, TRANSIT) | `string` | `"PRIVATE"` | no |
| customer_bgp_asn | The BGP ASN for the customer side | `number` | `65000` | no |
| tags | A map of tags to assign to the resources | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| gateway_id | The ID of the Direct Connect Gateway |
| connection_id | The ID of the Direct Connect connection |
| connection_arn | The ARN of the Direct Connect connection |
| vif_id | The ID of the virtual interface |
| vif_arn | The ARN of the virtual interface |
| tags | A map of tags assigned to the connection |
