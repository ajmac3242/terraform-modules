variable "zone_id" {
  description = "The ID of the hosted zone"
  type        = string
}

variable "records" {
  description = "A list of records to create"
  type = list(object({
    name    = string
    type    = string
    ttl     = number
    records = list(string)
  }))
}
