variable "vpc_id" {
  description = "The VPC ID where the subnet will be created"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the subnet"
  type        = string
}

variable "availability_zone" {
  description = "The AZ for the subnet"
  type        = string
}

variable "map_public_ip_on_launch" {
  description = "Indicates whether instances launched into the subnet should be assigned a public IP address"
  type        = bool
  default     = false
}

variable "name" {
  description = "Name tag for the subnet"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)

  validation {
    condition     = contains(keys(var.tags), "environment") && contains(keys(var.tags), "owner") && contains(keys(var.tags), "project") && contains(keys(var.tags), "cost_center")
    error_message = "The tags map must contain the following keys: environment, owner, project, cost_center."
  }
}

variable "aws_account_id" {
  description = "The AWS Account ID to support tests/mocking"
  type        = string
  default     = null
}
