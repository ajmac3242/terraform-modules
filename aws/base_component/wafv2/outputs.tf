output "web_acl_arn" {
  description = "The ARN of the Web ACL"
  value       = aws_wafv2_web_acl.this.arn
}

output "web_acl_id" {
  description = "The ID of the Web ACL"
  value       = aws_wafv2_web_acl.this.id
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = aws_wafv2_web_acl.this.tags_all
}
