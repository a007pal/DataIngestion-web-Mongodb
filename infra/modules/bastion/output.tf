output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
  description = "Use this to SSH into bastion"
}
