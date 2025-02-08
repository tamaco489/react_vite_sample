# AWS Managed Rules
# NOTE: https://dev.classmethod.jp/articles/aws-wafv2-wcus-limit-increase/

# TTL WCU: 1475

# 1. Amazon IP レピュテーション リスト マネージド ルール グループ
# AWSManagedRulesAmazonIpReputationList
# WCU: 25
# https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-ip-rep.html#aws-managed-rule-groups-ip-rep-amazon

# 2. 匿名 IP リスト管理ルール グループ
# AWSManagedRulesAnonymousIpList
# WCU: 50
# https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-ip-rep.html#aws-managed-rule-groups-ip-rep-anonymous

# 3. コアルールセット (CRS) 管理ルールグループ
# AWSManagedRulesCommonRuleSet
# WCU: 700
# https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-baseline.html#aws-managed-rule-groups-baseline-crs

# 4. 既知の不正な入力を管理するルール グループ
# AWSManagedRulesKnownBadInputsRuleSet
# WCU: 200
# https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-baseline.html#aws-managed-rule-groups-baseline-known-bad-inputs

# 5. Linuxシステムに関連する既知の脆弱性や攻撃から保護
# AWSManagedRulesLinuxRuleSet
# WCU: 200
# https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-use-case.html#aws-managed-rule-groups-use-case-linux-os

# 6. SQL データベース管理ルール グループ
# AWSManagedRulesSQLiRuleSet
# WCU: 200
# https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-use-case.html#aws-managed-rule-groups-use-case-sql-db

# 7. 管理者保護管理ルールグループ
# AWSManagedRulesAdminProtectionRuleSet
# WCU: 100
# https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-baseline.html#aws-managed-rule-groups-baseline-admin

resource "aws_wafv2_web_acl" "web_front" {
  name  = "${local.fqn}-web-front"
  scope = "CLOUDFRONT"

  default_action {
    allow {}
  }

  # WCU: 25
  # 1. 不正なIPアドレス（例えばスパム、ボットなど）を持つリクエストをブロック。
  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 0

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = true
    }
  }

  # WCU: 50
  # 2. 匿名IPアドレス（例えばVPNやプロキシ）からのリクエストを処理。
  rule {
    name     = "AWS-AWSManagedRulesAnonymousIpList"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"

        rule_action_override {
          name = "HostingProviderIPList"

          action_to_use {
            count {}
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAnonymousIpList"
      sampled_requests_enabled   = true
    }
  }

  # WCU: 700
  # 3. 一般的な攻撃（クロスサイトスクリプティングやSQLインジェクションなど）を検出し、対応。
  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"

        rule_action_override {
          name = "SizeRestrictions_QUERYSTRING"

          action_to_use {
            count {}
          }
        }

        rule_action_override {
          name = "SizeRestrictions_Cookie_HEADER"
          action_to_use {
            count {}
          }
        }

        rule_action_override {
          name = "SizeRestrictions_BODY"
          action_to_use {
            count {}
          }
        }

        rule_action_override {
          name = "SizeRestrictions_URIPATH"
          action_to_use {
            count {}
          }
        }

        rule_action_override {
          name = "CrossSiteScripting_BODY" # https://repost.aws/ja/knowledge-center/waf-upload-blocked-files
          action_to_use {
            count {}
          }
        }

        rule_action_override {
          name = "GenericLFI_BODY" # https://repost.aws/ja/knowledge-center/waf-upload-blocked-files
          action_to_use {
            count {}
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  # WCU: 200
  # 4. 特定の悪意のある入力や攻撃からアプリケーションを保護する。
  rule {
    name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority = 3

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = true
    }
  }

  # WCU: 200
  # 5. Linuxシステムに関連する既知の脆弱性や攻撃から保護
  rule {
    name     = "AWS-AWSManagedRulesLinuxRuleSet"
    priority = 4

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesLinuxRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesLinuxRuleSet"
      sampled_requests_enabled   = true
    }
  }

  # WCU: 200
  # 6. SQLインジェクションを防止。
  rule {
    name     = "AWS-AWSManagedRulesSQLiRuleSet"
    priority = 5

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"

        rule_action_override {
          name = "SQLi_BODY" # https://repost.aws/ja/knowledge-center/waf-upload-blocked-files
          action_to_use {
            count {}
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesSQLiRuleSet"
      sampled_requests_enabled   = true
    }
  }

  # WCU: 100
  # 7. 理者が使用するウェブアプリケーションの管理インターフェースやAPIなどに対する攻撃を防ぐ。
  rule {
    name     = "AWS-AWSManagedRulesAdminProtectionRuleSet"
    priority = 6

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAdminProtectionRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAdminProtectionRuleSet"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${local.fqn}-wafv2"
    sampled_requests_enabled   = true
  }
}
