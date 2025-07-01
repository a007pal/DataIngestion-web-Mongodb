resource "aws_security_group" "lambda_sg" {
  name =  "${var.funtion_name}-lambda-sg"
  description = "Security group for Lambda function"
  vpc_id = aws_vpc.lambda_vpc.id
  ingress {
    description = "Allow Internal Vpc traffic"
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress {
    description = "Allow all outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.funtion_name}-lambda-sg"
  }
}