# Github Actions で AWS のdeployタスクを実行できるように、OIDC経由でロールを引き受けるための定義
# CI/CD workflow で使用され、GitHub Actions からの OIDC 認証に基づいてアクセスを許可する。
resource "aws_iam_role" "github_actions_oidc" {
  name               = "${local.fqn}-github-actions-oidc-role"
  description        = "This IAM role allows GitHub Actions to assume the role via OIDC for performing deployment tasks on AWS, such as managing resources in the associated repository (repo: tamaco489/react_vite_sample). The role is used for CI/CD workflows and grants access based on OIDC authentication from GitHub Actions."
  assume_role_policy = data.aws_iam_policy_document.github_actions_oidc.json

  tags = {
    Name = "${local.fqn}-github-actions-oidc-role"
  }
}

resource "aws_iam_role_policy_attachment" "github_actions_oidc" {
  role       = aws_iam_role.github_actions_oidc.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data "aws_iam_policy_document" "github_actions_oidc" {
  statement {
    sid = "GithubActionsOIDCAssumeRole"
    principals {
      type = "Federated"
      identifiers = [
        var.github_actions_oidc_provider_arn
      ]
    }
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:tamaco489/react_vite_sample:*"
      ]
    }
  }
}

