variable "name" {
  description = "The name of the Web ACL"
  type        = string
}

variable "scope" {
  description = "The scope of this Web ACL. Valid values are CLOUDFRONT and REGIONAL"
  type        = string
  default     = "REGIONAL"

  validation {
    condition     = contains(["CLOUDFRONT", "REGIONAL"], var.scope)
    error_message = "The scope must be either CLOUDFRONT or REGIONAL."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)

  validation {
    condition     = contains(keys(var.tags), "environment") && contains(keys(var.tags), "owner") && contains(keys(var.tags), "project") && contains(keys(var.tags), "cost_center")
    error_message = "The tags map must contain the following keys: environment, owner, project, cost_center."
  }
}
