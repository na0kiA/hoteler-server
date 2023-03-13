resource "aws_db_subnet_group" "this" {
  name = aws_vpc.this.tags.Name

  subnet_ids = [
    for s in aws_subnet.private : s.id
  ]

  tags = {
    Name = aws_vpc.this.tags.Name
  }
}

resource "aws_db_parameter_group" "this" {
  name = local.service_name

  family = "mysql8.0"

  parameter {
    name  = "character_set_client"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_connection"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_filesystem"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_results"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "collation_server"
    value = "utf8mb4_0900_ai_ci"
  }

  parameter {
    name  = "general_log"
    value = "1"
  }

  parameter {
    name  = "slow_query_log"
    value = "1"
  }

  parameter {
    name  = "long_query_time"
    value = "1.0"
  }

  parameter {
    name  = "log_output"
    value = "FILE"
  }

  tags = {
    Name = "${local.service_name}"
  }
}

resource "aws_db_instance" "this" {
  engine         = "mysql"
  engine_version = "8.0.27"
  identifier     = "hoteler-server-db"

  username = "admin"
  password = "MustChangeStrongPassword!"

  instance_class = "db.t3.micro"

  storage_type          = "gp2"
  allocated_storage     = 20
  max_allocated_storage = 0

  multi_az = false

  db_subnet_group_name = data.terraform_remote_state.network_main.outputs.db_subnet_group_this_id
  publicly_accessible  = false
  vpc_security_group_ids = [
    data.terraform_remote_state.network_main.outputs.security_group_db_hoteler_id,
  ]
  availability_zone = "ap-northeast-1a"
  port              = 3306

  iam_database_authentication_enabled = false

  db_name              = "hoteler_server_db"
  parameter_group_name = aws_db_parameter_group.this.name

  backup_retention_period  = 1
  backup_window            = "17:00-18:00"
  copy_tags_to_snapshot    = true
  delete_automated_backups = true
  skip_final_snapshot      = true

  performance_insights_enabled = false


  enabled_cloudwatch_logs_exports = [
    "error",
    "general",
    "slowquery"
  ]

  auto_minor_version_upgrade = false
  maintenance_window         = "fri:18:00-fri:19:00"

  deletion_protection = false

  tags = {
    Name = "${local.service_name}"
  }
}