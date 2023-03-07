resource "aws_cloudwatch_log_group" "nginx" {
  name = "/ecs/${local.service_name}/nginx"

  retention_in_days = 90
}

resource "aws_cloudwatch_log_group" "ruby" {
  name = "/ecs/${local.service_name}/ruby"

  retention_in_days = 90
}