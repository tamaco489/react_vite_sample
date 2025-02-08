data "terraform_remote_state" "cloudfront" {
  backend = "s3"
  config = {
    bucket = "${var.env}-react-vite-sample-tfstate"
    key    = "cloudfront/terraform.tfstate"
  }
}

# Web Front S3 バケットのIAMポリシードキュメントの定義
# CloudFrontからのアクセスに対して、特定の条件のもとでS3バケット内のオブジェクトをGetObjectアクションでアクセスできるように設定。
data "aws_iam_policy_document" "web_front" {
  statement {
    effect = "Allow"

    # アクセスを許可するエンティティ（Principal）を `cloudfront.amazonaws.com` に指定。※CloudFrontサービスにアクセス権限を付与
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    # CloudFrontがS3バケット内のオブジェクトを参照することを許可。
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.web_front.arn}/*"]

    # ポリシーの適用に追加の条件を指定。
    # CloudFront のARNを指定し、リクエスト元のリソースが左記CloudFrontのArnと一致している場合のみ許可する。
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [data.terraform_remote_state.cloudfront.outputs.web_front.arn]
    }
  }
}
