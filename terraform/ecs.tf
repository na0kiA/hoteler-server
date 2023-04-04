resource "aws_ecs_cluster" "this" {
  name = local.service_name

  tags = {
    Name = "${local.service_name}"
  }
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name = aws_ecs_cluster.this.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_task_definition" "this" {
  family        = local.service_name
  task_role_arn = aws_iam_role.ecs_task.arn
  network_mode  = "awsvpc"
  requires_compatibilities = [
    "FARGATE",
  ]
  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  memory             = "512"
  cpu                = "256"

  container_definitions = jsonencode(
    [
      {
        name      = "nginx"
        memory    = 512
        essential = true
        image     = "${module.nginx.ecr_repository_this_repository_url}:latest"
        volumesFrom = [
          {
            readonly        = null,
            sourceContainer = "ruby"
          }
        ]
        portMappings = [
          {
            containerPort = 80
            protocol      = "tcp"
          }
        ]
        environment = []
        secrets = [
        ]
        dependsOn = [
          {
            containerName = "ruby"
            condition     = "START"
          }
        ]
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = "/ecs/${(local.service_name)}/nginx"
            awslogs-region        = data.aws_region.current.id
            awslogs-stream-prefix = "ecs"
          }
        }
      },
      {
        name         = "ruby"
        memory       = 512
        essential    = true
        image        = "${module.ruby.ecr_repository_this_repository_url}:latest"
        portMappings = []
        environment  = []
        secrets = [
          {
            name      = "RAILS_MASTER_KEY"
            valueFrom = "/${local.service_name}/RAILS_MASTER_KEY"
          },
          {
            name      = "DB_USERNAME",
            valueFrom = "/${local.service_name}/DB_USERNAME"
          },
          {
            name      = "DB_PASSWORD",
            valueFrom = "/${local.service_name}/DB_PASSWORD"
          },
          {
            name      = "DB_HOST",
            valueFrom = "/${local.service_name}/DB_HOST"
          }
        ]
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = "/ecs/${(local.service_name)}/ruby"
            awslogs-region        = data.aws_region.current.id
            awslogs-stream-prefix = "ecs"
          }
        }
      }
    ]
  )

  tags = {
    Name = "${local.service_name}"
  }
}

resource "aws_ecs_service" "this" {
  name    = local.service_name
  cluster = aws_ecs_cluster.this.arn

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    base              = 0
    weight            = 1
  }

  platform_version = "1.4.0"
  task_definition  = aws_ecs_task_definition.this.arn
  desired_count    = 1

  # ローリングアップデートの設定
  # deployment_minimum_healthy_percent = 100
  # deployment_maximum_percent         = 200

  load_balancer {
    container_name   = "nginx"
    container_port   = 80
    target_group_arn = data.terraform_remote_state.lovehoteler_com.outputs.lb_target_group_blue_tg_arn
  }

  health_check_grace_period_seconds = 3600

  network_configuration {
    assign_public_ip = true
    security_groups = [
      data.terraform_remote_state.network_main.outputs.security_group_ecs_id
    ]
    subnets = [
      for s in data.terraform_remote_state.network_main.outputs.subnet_public : s.id
      # data.terraform_remote_state.network_main.outputs.subnet_public["a"].id
    ]
  }

  enable_execute_command = true

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  lifecycle {
    ignore_changes = [task_definition, load_balancer]
  }

  tags = {
    Name = "${local.service_name}"
  }
}


# -------------------------------------------
# Auto Scaling
# -------------------------------------------
resource "aws_appautoscaling_target" "appautoscaling_ecs_target" {
  service_namespace  = "ecs"

  resource_id        = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.this.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  # role_arn           = data.aws_iam_role.ecs_service_autoscaling.arn

  min_capacity       = 1
  max_capacity       = 2
}

# data "aws_iam_role" "ecs_service_autoscaling" {
#   name = "AWSServiceRoleForApplicationAutoScaling_ECSService"
# }

resource "aws_appautoscaling_policy" "appautoscaling_scale_up" {
  name               = "hoteler-ecs-autoscaling-up"
  service_namespace  = "ecs"

  resource_id        = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.this.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 120
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}

resource "aws_appautoscaling_policy" "appautoscaling_scale_down" {
  name               = "hoteler-ecs-autoscaling-down"
  service_namespace  = "ecs"

  resource_id        = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.this.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 120
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "alarm_cpu_high" {
  alarm_name          = "hoteler_ecs_cpu_utilization_high"

  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"

  threshold           = "80"

  dimensions = {
    ClusterName = aws_ecs_cluster.this.name
    ServiceName = aws_ecs_service.this.name
  }

  alarm_actions = [aws_appautoscaling_policy.appautoscaling_scale_up.arn]
}

resource "aws_cloudwatch_metric_alarm" "alarm_cpu_low" {
  alarm_name          = "hoteler_ecs_cpu_utilization_low"

  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"

  threshold           =  "30"

  dimensions = {
    ClusterName = aws_ecs_cluster.this.name
    ServiceName = aws_ecs_service.this.name
  }

  alarm_actions = [aws_appautoscaling_policy.appautoscaling_scale_down.arn]
}


# -------------------------------------------
# CodeDeploy
# -------------------------------------------
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "example" {
  name               = "example-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
  role       = aws_iam_role.example.name
}

resource "aws_codedeploy_app" "codedeploy_app" {
  compute_platform = "ECS"
  name             = "${local.service_name}-codedeploy-app"
}

resource "aws_codedeploy_deployment_group" "codedeploy_dg" {
  app_name               = aws_codedeploy_app.codedeploy_app.name
  deployment_group_name  = "${local.service_name}-codedeploy-dg"
  service_role_arn       = aws_iam_role.example.arn
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = aws_ecs_cluster.this.name
    service_name = aws_ecs_service.this.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [aws_lb_listener.https.arn]
      }

      target_group {
        name = aws_lb_target_group.blue_tg.name
      }

      target_group {
        name = aws_lb_target_group.green_tg.name
      }
    }
  }
}