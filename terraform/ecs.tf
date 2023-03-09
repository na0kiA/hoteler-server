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
  family = local.service_name

  # iamに 
  # task_role_arn = aws_iam_role.ecs_task.arn

  network_mode = "awsvpc"
  requires_compatibilities = [
    "FARGATE",
  ]
  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  memory             = "512"
  cpu                = "256"
  container_definitions = jsonencode(
    [
      {
        name  = "nginx"
        image = "${module.nginx.ecr_repository_this_repository_url}:latest"
        portMappings = [
          {
            containerPort = 80
            protocol      = "tcp"
          }
        ]
        environment = []
        secrets     = []
        dependsOn = [
          {
            containerName = "ruby"
            condition     = "START"
          }
        ]
        # mountPoints = [
        #   {
        #     containerPath = "/var/run/ruby-fpm"
        #     sourceVolume  = "ruby-fpm-socket"
        #   }
        # ]
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
        image        = "${module.ruby.ecr_repository_this_repository_url}:latest"
        portMappings = []
        environment  = []
        secrets = [
          {
            name      = "DB_USERNAME",
            valueFrom = "/container-param/db-username"
          },
          {
            name      = "DB_PASSWORD",
            valueFrom = "/container-param/db-password"
          },
          {
            name      = "DB_HOST",
            valueFrom = "/container-param/db-host"
          }
        ]
        # mountPoints = [
        #   {
        #     containerPath = "/var/run/ruby-fpm"
        #     sourceVolume  = "ruby-fpm-socket"
        #   }
        # ]
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
  volume {
    name = "ruby-fpm-socket"
  }
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
  platform_version                   = "1.69.0"
  task_definition                    = aws_ecs_task_definition.this.arn
  desired_count                      = var.desired_count
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  load_balancer {
    container_name   = "nginx"
    container_port   = 80
    target_group_arn = data.terraform_remote_state.lovehoteler_com.outputs.lb_target_group_foobar_arn
  }
  health_check_grace_period_seconds = 60
  network_configuration {
    assign_public_ip = true
    security_groups = [
      data.terraform_remote_state.network_main.outputs.security_group_vpc_id
    ]
    subnets = [
      for s in data.terraform_remote_state.network_main.outputs.subnet_public : s.id
    ]
  }
  enable_execute_command = true
  tags = {
    Name = "${local.service_name}"
  }
}