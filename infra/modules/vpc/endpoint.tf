resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.region}.s3"
  route_table_ids = [
    aws_route_table.private.id
  ]
  vpc_endpoint_type = "Gateway"
  tags              = {
    name = "${var.name_prefix}-s3-endpoint"
  }
}
resource "aws_vpc_endpoint" "secretmanger" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [aws_security_group.secertmanger_endpoint_sg_id.id]
  private_dns_enabled = true
  tags = {
    name = "${var.name_prefix}-secmgr-endpoint"
  }
}
