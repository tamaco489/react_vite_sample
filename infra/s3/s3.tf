# Web Front S3 バケットの定義
resource "aws_s3_bucket" "web_front" {
  bucket = "${local.fqn}-web-front"

  # 誤削除の防止 (terraform destroy で削除されない)
  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "${local.fqn}-web-front"
  }
}

# S3 のパブリックアクセス制限
resource "aws_s3_bucket_public_access_block" "web_front" {
  bucket                  = aws_s3_bucket.web_front.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Web Front S3 バケットに対してバケットポリシーを適用
resource "aws_s3_bucket_policy" "web_admin" {
  bucket = aws_s3_bucket.web_front.id
  policy = data.aws_iam_policy_document.web_front.json
}
