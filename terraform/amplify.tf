resource "aws_amplify_app" "this" {
  name         = "hoteler-client"
  repository   = "https://github.com/na0kiA/hoteler-client"
  iam_service_role_arn = aws_iam_role.amplify-codecommit.arn
  access_token = var.github_token_for_amplify

  build_spec = <<-EOT
    version: 1
    frontend:
      phases:
        preBuild:
          commands:
            - yarn install
        build:
          commands:
            - yarn run build
      artifacts:
        baseDirectory: .next
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT


  enable_auto_branch_creation = false
  enable_branch_auto_build    = false
  enable_branch_auto_deletion = false
  platform                    = "WEB_COMPUTE"

  custom_rule {
    source = "/<*>"
    status = "404-200"
    target = "/index.html"  
  }


  auto_branch_creation_config {
    enable_pull_request_preview = true
    environment_variables = {
      NEXT_PUBLIC_API_URL = "https://api.hoteler.jp"
    }
  }
}

resource "aws_amplify_branch" "this" {
  app_id      = aws_amplify_app.this.id
  branch_name = "develop"

  enable_auto_build = true

  framework = "Next.js - SSR"
  stage     = "DEVELOPMENT"


  environment_variables = {
    NEXT_PUBLIC_API_URL = "https://api.hoteler.jp"
  }
}

resource "aws_amplify_domain_association" "this" {
  app_id      = aws_amplify_app.this.id
  domain_name = "hoteler.jp"

  sub_domain {
    branch_name = aws_amplify_branch.this.branch_name
    prefix      = ""
  }

  sub_domain {
    branch_name = aws_amplify_branch.this.branch_name
    prefix      = "www"
  }
}