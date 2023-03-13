# -------------------------------------------
# S3: デプロイ用のユーザー
# -------------------------------------------
resource "aws_iam_user" "github" {
  name = "${local.service_name}-github"

  tags = {
    Name = "${local.service_name}-github"
  }
}

resource "aws_iam_role" "deployer" {
  name = "${local.service_name}-deployer"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "sts:AssumeRole",
            "sts:TagSession"
          ],
          "Principal" : {
            "AWS" : aws_iam_user.github.arn
          },
        }
      ]
    }
  )

  tags = {
    Name = "${local.service_name}-deployer"
  }
}

data "aws_iam_policy" "ecr_power_user" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_role_policy_attachment" "role_deployer_policy_ecr_power_user" {
  role       = aws_iam_role.deployer.name
  policy_arn = data.aws_iam_policy.ecr_power_user.arn
}

# -------------------------------------------
# github actionsでタスク定義ファイルを作成するための権限
# -------------------------------------------
resource "aws_iam_policy" "ecs_task_describe" {
  name = "${local.service_name}-ecs-task-describe"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : ["ecs:DescribeTaskDefinition", "ecs:RegisterTaskDefinition", "ecs:DescribeTasks", "ecs:ListTasks"]
          "Resource" : "*"
        },
      ]
    }
  )

  tags = {
    Name = "${local.service_name}-ecs-task-describe"
  }
}

resource "aws_iam_role_policy_attachment" "role_deployer_policy_ecs_task_describe" {
  role       = aws_iam_role.deployer.name
  policy_arn = aws_iam_policy.ecs_task_describe.arn
}

resource "aws_iam_policy" "ecs_pass_role" {
  name        = "${local.service_name}-ecs-pass-role"
  description = "Policy to allow IAM role pass role permission"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "iam:PassRole"
        Effect   = "Allow"
        Resource = "arn:aws:iam::${data.aws_caller_identity.self.account_id}:role/hoteler-ecs-task-execution"
      },
    ]
  })

  tags = {
    Name = "${local.service_name}-ecs-pass-role"
  }
}

resource "aws_iam_role_policy_attachment" "deployer-ecs-pass-role" {
  policy_arn = aws_iam_policy.ecs_pass_role.arn
  role       = aws_iam_role.deployer.name
}

# -------------------------------------------
# ECSタスク実行ロール
# -------------------------------------------
resource "aws_iam_role" "ecs_task_execution" {
  name = "${local.service_name}-ecs-task-execution"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "ecs-tasks.amazonaws.com"
          },
          "Action" : ["sts:AssumeRole"]
        }
      ]
    }
  )

  tags = {
    Name = "${local.service_name}-ecs-task-execution"
  }
}

data "aws_iam_policy" "ecs_task_execution" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = data.aws_iam_policy.ecs_task_execution.arn
}

# -------------------------------------------
# ECSからパラメータストア取得用のポリシー
# -------------------------------------------
resource "aws_iam_policy" "ssm" {
  name = "${local.service_name}-ssm"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "ssm:GetParameters",
            "ssm:GetParameter"
          ],
          "Resource" : "arn:aws:ssm:${data.aws_region.current.id}:${data.aws_caller_identity.self.account_id}:parameter/*"
        }
      ]
    }
  )

  tags = {
    Name = "${local.service_name}-ssm"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_ssm" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.ssm.arn
}

# -------------------------------------------
# ECS Execを利用するためのロール
# -------------------------------------------
resource "aws_iam_role_policy" "ecs_task_ssm" {
  name = "ssm"
  role = aws_iam_role.ecs_task.id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "ssmmessages:CreateControlChannel",
            "ssmmessages:CreateDataChannel",
            "ssmmessages:OpenControlChannel",
            "ssmmessages:OpenDataChannel"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
}

resource "aws_iam_role" "ecs_task" {
  name = "${local.service_name}-ecs-task"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "ecs-tasks.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )

  tags = {
    Name = "${local.service_name}-ecs-task"
  }
}


# -------------------------------------------
# S3: 画像アップロード用のユーザー
# -------------------------------------------
resource "aws_iam_user" "hoteler-s3-uploader" {
  name = "${local.service_name}-s3-uploader"

  tags = {
    Name = "${local.service_name}-s3-uploader"
  }
}

resource "aws_iam_user_policy_attachment" "s3_fullaccess_user_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  user       = aws_iam_user.hoteler-s3-uploader.name
}