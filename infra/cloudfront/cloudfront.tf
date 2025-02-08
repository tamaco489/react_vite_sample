# CloudFront の Origin Access Control (OAC) を設定
# OAC: CloudFront -> S3 バケットにアクセスする際の認証を管理するために使用。このリソースにより CloudFront -> S3 バケットへのアクセスを制御する。
# Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control
resource "aws_cloudfront_origin_access_control" "web_front" {
  name                              = "${var.env}-react-vite-sample-web-front"
  description                       = "origin access controll for ${var.env} web front"

  # CloudFront のオリジンのタイプを `s3` に指定。つまり、アクセス制御が S3 バケットに対して設定されていることを意味する。
  # CloudFront からのリクエストが S3 バケットへ向かう場合、この設定が適用される。※他にはlambda, mediapackagev2, mediastore の指定が可能。
  origin_access_control_origin_type = "s3"

  # CloudFront がリクエストをオリジンに転送する際に、リクエストの署名の扱いを `always` に指定。
  # always: CloudFront からのすべてのリクエストに対して署名を行う。※セキュリティレベルを高めるため、常に署名が必要となるように設定。
  signing_behavior                  = "always"

  # 署名プロトコルを `sigv4` に指定。※現時点で `sigv4` 以外の署名プロトコルを指定することは不可能。
  signing_protocol                  = "sigv4"
}

# CloudFront の設定
# S3 バケットからコンテンツを配信し、HTTPS でアクセスを提供するように構成。
# Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution
resource "aws_cloudfront_distribution" "web_front" {
  # ==============================
  # 1. 一般設定
  # ==============================
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "react vite sample web front"

  # 代替ドメイン名（CNAME）を指定
  aliases             = [var.web_front_domain]

  # デフォルトルートオブジェクトの指定: ルートURLでリクエストされた際に CloudFront が返すオブジェクト。
  # `www.halu-ulala-proto.com` でリクエストされた場合、`www.halu-ulala-proto.com/index.html` として返す。
  default_root_object = "index.html"


  # ==============================
  # 2. セキュリティ設定
  # ==============================
  # AWS WAFv2 Web ACL（Web Application Firewall）の設定 ※CloudFront に適用されるセキュリティルールを定義したリソースを適用している
  web_acl_id = aws_wafv2_web_acl.web_front.arn

  # 地域制限設定（Geo Restriction）
  # 特定の国や地域からのリクエストを許可、またはブロックする。
  # 以下は日本とアメリカ以外の地域からのアクセスはブロックし、左記二国からのみコンテンツが配信される。
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["JP", "US"]
    }
  }

  # ==============================
  # 3. オリジン設定
  # ==============================
  origin {
    # CloudFront -> S3 バケットにアクセスするためのアクセスコントロール設定（署名付きでリクエストが行われるようになる）
    origin_access_control_id = aws_cloudfront_origin_access_control.web_front.id

    domain_name              = data.terraform_remote_state.s3.outputs.web_front.bucket_regional_domain_name
    origin_id                = data.terraform_remote_state.s3.outputs.web_front.bucket_regional_domain_name
  }

  # ==============================
  # 4. ビヘイビア設定
  # ==============================
  # CloudFront ディストリビューションのデフォルトのキャッシュ挙動を定義
  default_cache_behavior {
    # CloudFront が許可するHTTP Method、及びキャッシュするHTTP Methodを指定
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    # キャッシュ対象のオリジンを識別するための ID を S3 バケットのドメイン名に指定。
    target_origin_id       = data.terraform_remote_state.s3.outputs.web_front.bucket_regional_domain_name

    # コンテンツ圧縮機能を有効に指定。
    # クライアント（ブラウザや他のクライアント）が送信する HTTP リクエストヘッダに Accept-Encoding: gzip が含まれていた場合、
    # そのリクエストに対するレスポンスとして、CloudFront が 圧縮可能なコンテンツ（例えば、テキストやHTML、CSS、JSなど）を自動的に圧縮して配信する。
    # データ転送量の削減、ページ読み込みの高速化の利点がある一方、
    compress               = true

    # キャッシュ時のポリシーを指定（マネージドのポリシーを利用する）
    cache_policy_id        = data.aws_cloudfront_cache_policy.caching_optimized.id

    # ビューアーからの Cloudfront に対して要求するプロトコルを `HTTPSのみ有効` として設定
    viewer_protocol_policy = "https-only"

    # Cloudfront Function との関連付け
    function_association {
      # CloudFront Function の場合は `viewer-request`、または `viewer-response` のいずれかを指定可能。
      # ※オリジンへのリクエスト、レスポンスの処理は不可能
      # 全てのリクエストに対して、CloudFrontのキャッシュを確認する前に、basic認証を有効にするために `viewer-request` に指定
      # doc: https://aws.amazon.com/jp/blogs/news/lambdaedge-design-best-practices/
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.web_front.arn
    }
  }

  # ==============================
  # 5. エラーページ設定
  # ==============================
  # カスタムエラーレスポンスの設定
  custom_error_response {
    # エラーページをキャッシュする最小TTLを60秒に指定（エラーが頻発している場合でも指定したTTL期間が経過するまでは同じエラーページを返し続ける）。
    # エラー発生時は、通常の403 Forbiddenレスポンスの代わりに、200 OKレスポンスを返し、オリジンからの実際のページではなく、「/」のホーム画面にリダイレクトさせる。
    error_caching_min_ttl = 60
    error_code            = 403
    response_code         = 200
    response_page_path    = "/"
  }

  # 料金クラスの指定。
  # `PriceClass_100` が最も安価であるが、日本リージョンは未対応
  # Reference: https://aws.amazon.com/jp/cloudfront/pricing/
  price_class = "PriceClass_200"

  viewer_certificate {
    # CloudFrontで使用するSSL/TLS証明書を、ACMで発行した証明書のARNに指定。
    acm_certificate_arn            = data.terraform_remote_state.acm.outputs.cloudfront.arn

    # ACMで発行した証明書を利用するため、CloudFrontのデフォルトの証明書は使用しない。
    cloudfront_default_certificate = false

    # TLSプロトコルのバージョンを設定。
    # "TLSv1.0"〜"TLSv1.3": 各種TLSバージョンを指定可能だが、以下はTLS 1.2を最小バージョンとして指定。※つまり、これよりも弱いTLSバージョンは使用しない。
    minimum_protocol_version       = "TLSv1.2_2021"

    # CloudFrontにHTTPSリクエストを処理させる方法。vip、sni-only、static-ip のいずれかを指定。※acm_certificate_arn または iam_certificate_id を指定した場合は必須。
    # 注意：vipを指定するした場合、CloudFrontは専用IPアドレスを使用し、追加料金が発生する可能性がある。
    # wiki: https://ja.wikipedia.org/wiki/Server_Name_Indication
    ssl_support_method             = "sni-only"
  }

  tags       = { Name = "${local.fqn}-web-front" }
}
