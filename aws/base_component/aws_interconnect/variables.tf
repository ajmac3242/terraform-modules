variable "name" {
  description = "The name of the Interconnect gateway"
  type        = string
}

variable "cloud_provider" {
  description = "The cloud provider to interconnect with. Valid values: OCI, AZURE."
  type        = string

  validation {
    condition     = contains(["OCI", "AZURE"], var.cloud_provider)
    error_message = "The cloud_provider variable must be either OCI or AZURE."
  }
}

variable "bandwidth" {
  description = "The bandwidth of the interconnect connection. Valid values: 1Gbps, 10Gbps."
  type        = string
  default     = "1Gbps"

  validation {
    condition     = contains(["1Gbps", "10Gbps"], var.bandwidth)
    error_message = "The bandwidth variable must be either 1Gbps or 10Gbps."
  }
}

variable "location" {
  description = "The Direct Connect location for the connection"
  type        = string
}

variable "amazon_side_asn" {
  description = "The Autonomous System Number (ASN) for the Amazon side of the gateway. Valid values: 64512-65534 or 4294967294."
  type        = string
  default     = "64512"

  validation {
    condition     = (tonumber(var.amazon_side_asn) >= 64512 && tonumber(var.amazon_side_asn) <= 65534) || var.amazon_side_asn == "4294967294"
    error_message = "The amazon_side_asn must be between 64512 and 65534, or equal to 4294967294."
  }
}

variable "vlan" {
  description = "The VLAN ID for the virtual interface"
  type        = number
}

variable "customer_bgp_asn" {
  description = "The BGP ASN for the customer side of the virtual interface. Valid values: 1-65534 or 4294967294."
  type        = number
  default     = 65000

  validation {
    condition     = (var.customer_bgp_asn >= 1 && var.customer_bgp_asn <= 65534) || var.customer_bgp_asn == 4294967294
    error_message = "The customer_bgp_asn must be between 1 and 65534, or equal to 4294967294."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resources. Must include environment, owner, project, and cost_center."
  type        = map(string)

  validation {
    condition     = alltrue([for k in ["environment", "owner", "project", "cost_center"] : contains(keys(var.tags), k)])
    error_message = "The tags map must contain the following keys: environment, owner, project, cost_center."
  }
}
