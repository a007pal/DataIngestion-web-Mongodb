output "broker_private_ips" {
  value       = aws_instance.kafka[*].private_ip
  description = "Private IPs of Kafka brokers"
}

output "bootstrap_servers" {
  value       = join(",", [for i in aws_instance.kafka : "${i.private_ip}:9093"])
  description = "Kafka bootstrap servers with TLS port"
}

output "broker_instance_ids" {
  value       = aws_instance.kafka[*].id
  description = "Instance IDs of Kafka brokers"
}
output "broker_public_ips" {
  value       = aws_instance.kafka[*].public_ip
  description = "Public IPs of Kafka brokers (if assigned)"
}
