output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "lambda_sg_id" {
  value = aws_security_group.lambda.id
}

output "kafka_sg_id" {
  value = aws_security_group.kafka.id
}
output "zookeeper_sg_id" {
  value = aws_security_group.zookeeper.id
  
}