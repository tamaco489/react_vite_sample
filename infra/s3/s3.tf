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
  block_public_acls       = true # バケット内のオブジェクトがパブリックACLを持てないようにする
  block_public_policy     = true # S3バケットのポリシーでパブリックアクセスを許可しない
  ignore_public_acls      = true # 既存のパブリックACLを無視し、強制的に拒否
  restrict_public_buckets = true # バケットポリシーでパブリックアクセスが許可されていても制限する
}
