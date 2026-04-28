# Athena Workgroup with enforced security settings
resource "aws_athena_workgroup" "this" {
  name        = var.name
  description = var.description

  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = var.publish_cloudwatch_metrics_enabled
    bytes_scanned_cutoff_per_query     = var.bytes_scanned_cutoff_per_query

    result_configuration {
      output_location = var.output_location

      encryption_configuration {
        encryption_option = "SSE_KMS"
        kms_key_arn       = var.kms_key_arn
      }
    }
  }

  tags = var.tags
}
