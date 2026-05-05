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
  description = "The Autonomous System Number (ASN) for the Amazon side of the gateway"
  type        = string
  default     = "64512"
}

variable "vlan" {
  description = "The VLAN ID for the virtual interface"
  type        = number
}

variable "customer_bgp_asn" {
  description = "The BGP ASN for the customer side of the virtual interface"
  type        = number
  default     = 65000
}

variable "tags" {
  description = "A map of tags to assign to the resources. Must include environment, owner, project, and cost_center."
  type        = map(string)

  validation {
    condition     = alltrue([for k in ["environment", "owner", "project", "cost_center"] : contains(keys(var.tags), k)])
    error_message = "The tags map must contain the following keys: environment, owner, project, cost_center."
  }
}
