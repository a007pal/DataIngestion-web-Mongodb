resource "aws_security_group" "lambda" {
    name = "${var.name_prefix}-lambda-sg" 
    description = "Security group for Lambda TO Kafka"
    vpc_id = aws_vpc.main.id
    tags = var.tags
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "kafka" {
    name = "${var.name_prefix}-kafka-sg" 
    description = "Security group for Lambda TO Kafka"
    vpc_id = aws_vpc.main.id
    tags = var.tags
    ingress {
        from_port = 9093
        to_port = 9093
        protocol = "tcp"
        security_groups = [aws_security_group.lambda.id]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}