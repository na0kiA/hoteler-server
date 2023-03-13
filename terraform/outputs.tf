output "s3_bucket_this_id" {
  value = aws_s3_bucket.this.id
}

# ALBの作成のためにのサブネットのIDとセキュリティグループのID
output "security_group_web_id" {
  value = aws_security_group.web.id
}

output "security_group_ecs_id" {
  value = aws_security_group.ecs.id
}

output "security_group_db_hoteler_id" {
  value = aws_security_group.db.id
}

output "subnet_public" {
  value = aws_subnet.public
}

output "subnet_private" {
  value = aws_subnet.private
}

output "vpc_this_id" {
  value = aws_vpc.this.id
}

output "lb_target_group_blue_tg_arn" {
  value = aws_lb_target_group.blue_tg.arn
}

output "db_subnet_group_this_id" {
  value = aws_db_subnet_group.this.id
}

# output "rds_endpoint" {
#   value = aws_db_instance.this.address
# }