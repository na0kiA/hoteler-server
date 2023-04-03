# resource "aws_network_acl" "this" {
#   vpc_id = aws_vpc.this.id
# }

# resource "aws_network_acl_rule" "this" {
#   network_acl_id = aws_network_acl.this.id
#   rule_number    = 200
#   egress         = false
#   protocol       = "tcp"
#   rule_action    = "allow"
#   cidr_block     = aws_vpc.this.cidr_block
#   from_port      = 443
#   to_port        = 443
# }