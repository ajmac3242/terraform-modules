# Main EFS File System resource
resource "aws_efs_file_system" "this" {
  creation_token = var.name

  performance_mode = var.performance_mode
  throughput_mode  = var.throughput_mode

  # Enforce encryption with CMK
  encrypted  = true
  kms_key_id = var.kms_key_arn

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}

# Enforce Backup Policy
resource "aws_efs_backup_policy" "this" {
  file_system_id = aws_efs_file_system.this.id

  backup_policy {
    status = "ENABLED"
  }
}
