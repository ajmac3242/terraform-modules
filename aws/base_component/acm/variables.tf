variable "domain_name" {
  description = "The domain name for which the certificate should be issued"
  type        = string
}

variable "region" {
  description = "The AWS region to provision the certificate in (AWS Provider 6.0+)"
  type        = string
  default     = null
}

variable "validation_method" {
  description = "Which method to use for validation. DNS or EMAIL"
  type        = string
  default     = "DNS"

  validation {
    condition     = contains(["DNS", "EMAIL"], var.validation_method)
    error_message = "The validation_method must be either DNS or EMAIL."
  }
}

variable "subject_alternative_names" {
  description = "Set of domains that should be SANs in the issued certificate"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)

  validation {
    condition     = contains(keys(var.tags), "environment") && contains(keys(var.tags), "owner") && contains(keys(var.tags), "project") && contains(keys(var.tags), "cost_center")
    error_message = "The tags map must contain the following keys: environment, owner, project, cost_center."
  }
}
