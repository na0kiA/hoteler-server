output "s3_bucket_this_id" {
  value = aws_s3_bucket.this.id
}


# ALBの作成のためにのサブネットのIDとセキュリティグループのID
output "security_group_web_id" {
  value = aws_security_group.web.id
}

output "security_group_vpc_id" {
  value = aws_security_group.vpc.id
}

# output "security_group_db_hoteler_id" {
#   value = aws_security_group.db_hoteler.id
# }

output "subnet_public" {
  value = aws_subnet.public
}

# output "subnet_private" {
#   value = aws_subnet.private
# }

output "vpc_this_id" {
  value = aws_vpc.this.id
}

# output "db_subnet_group_this_id" {
#   value = aws_db_subnet_group.this.id
# }

output "lb_target_group_foobar_arn" {
  value = aws_lb_target_group.hoteler.arn
}