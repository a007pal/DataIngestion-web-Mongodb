resource "aws_vpc" "lambda_vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags={
        name = "${var.funtion_name}-vpc"
    }
}
# resource "aws_vpc_endpoint" "s3" {
#   vpc_id            = aws_vpc.lambda_vpc.id
#   service_name      = "com.amazonaws.${var.region}.s3"
#   vpc_endpoint_type = "Gateway"
#   route_table_ids   = [aws_route_table.private_rt.id]

#   tags = {
#     Name = "${var.funtion_name}-s3-endpoint"
#   }
# }