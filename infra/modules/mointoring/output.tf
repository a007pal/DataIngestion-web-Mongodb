output "akhq_public_ip" {
  value       = aws_instance.akhq.public_ip
  description = "Public IP of the AKHQ EC2 instance"
}

output "akhq_instance_id" {
  value       = aws_instance.akhq.id
  description = "ID of the AKHQ EC2 instance"
}

output "akhq_private_ip" {
  value       = aws_instance.akhq.private_ip
  description = "Private IP of the AKHQ EC2 instance (for VPC internal access)"
}
