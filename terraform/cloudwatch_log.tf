resource "aws_cloudwatch_log_group" "nginx" {
  name = "/ecs/${local.service_name}/nginx"

  retention_in_days = 90
}

resource "aws_cloudwatch_log_group" "ruby" {
  name = "/ecs/${local.service_name}/ruby"

  retention_in_days = 90
}

# resource "aws_cloudwatch_log_group" "error" {
#   name = "/aws/rds/instance/${local.service_name}/error"

#   retention_in_days = 90
# }

# resource "aws_cloudwatch_log_group" "general" {
#   name = "/aws/rds/instance/${local.service_name}/general"

#   retention_in_days = 90
# }

# resource "aws_cloudwatch_log_group" "slowquery" {
#   name = "/aws/rds/instance/${local.service_name}/slowquery"

#   retention_in_days = 90
# }