resource "aws_kms_key" "this" {
  description             = "KMS key for SOPS encryption"
  enable_key_rotation     = true
  rotation_period_in_days = 90
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.product}/${var.env}/sops"
  target_key_id = aws_kms_key.this.key_id
}
