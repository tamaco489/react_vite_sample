resource "aws_iam_role" "github_actions_oidc" {
  name               = "${local.fqn}-github-actions-oidc-role"
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

