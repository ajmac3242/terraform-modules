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

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
# See README.md for usage example
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | The cloud provider to interconnect with. Valid values: OCI, AZURE. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The Direct Connect location for the connection | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the Interconnect gateway | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources. Must include environment, owner, project, and cost\_center. | `map(string)` | n/a | yes |
| <a name="input_vlan"></a> [vlan](#input\_vlan) | The VLAN ID for the virtual interface | `number` | n/a | yes |
| <a name="input_amazon_side_asn"></a> [amazon\_side\_asn](#input\_amazon\_side\_asn) | The Autonomous System Number (ASN) for the Amazon side of the gateway. Valid values: 64512-65534 or 4294967294. | `string` | `"64512"` | no |
| <a name="input_bandwidth"></a> [bandwidth](#input\_bandwidth) | The bandwidth of the interconnect connection. Valid values: 1Gbps, 10Gbps. | `string` | `"1Gbps"` | no |
| <a name="input_customer_bgp_asn"></a> [customer\_bgp\_asn](#input\_customer\_bgp\_asn) | The BGP ASN for the customer side of the virtual interface. Valid values: 1-65534 or 4294967294. | `number` | `65000` | no |
| <a name="input_vif_type"></a> [vif\_type](#input\_vif\_type) | The type of virtual interface to create. Valid values: PRIVATE, TRANSIT. | `string` | `"PRIVATE"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connection_arn"></a> [connection\_arn](#output\_connection\_arn) | The ARN of the Direct Connect connection |
| <a name="output_connection_id"></a> [connection\_id](#output\_connection\_id) | The ID of the Direct Connect connection |
| <a name="output_gateway_id"></a> [gateway\_id](#output\_gateway\_id) | The ID of the Direct Connect Gateway |
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the connection |
| <a name="output_vif_arn"></a> [vif\_arn](#output\_vif\_arn) | The ARN of the virtual interface |
| <a name="output_vif_id"></a> [vif\_id](#output\_vif\_id) | The ID of the virtual interface |

<!-- END_TF_DOCS -->