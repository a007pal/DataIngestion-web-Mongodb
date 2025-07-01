# Route Table for private subnet
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.lambda_vpc.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  tags = {
    Name = "${var.funtion_name}-private-rt"
  }
}

# Associate private subnet to private route table
resource "aws_route_table_association" "private_subnet_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

# resource "aws_route" "private_s3_route" {
#   route_table_id = aws_route_table.private_rt.id
#   destination_cidr_block = "0.0.0.0/0"
#   vpc_endpoint_id = aws_vpc_endpoint.s3.id
#   depends_on = [aws_vpc_endpoint.s3]
# }