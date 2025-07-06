output "schema_registry_instance_id" {
  value       = aws_instance.schema_registry.id
  description = "ID of the Schema Registry EC2 instance"
}

output "schema_registry_private_ip" {
  value       = aws_instance.schema_registry.private_ip
  description = "Private IP of Schema Registry"
}

output "schema_registry_public_ip" {
  value       = aws_instance.schema_registry.public_ip
  description = "Public IP (if needed for access or monitoring)"
}

output "schema_registry_url" {
  value       = "https://${aws_instance.schema_registry.private_ip}:8081"
  description = "URL for Schema Registry using TLS (private VPC access)"
}
