resource "aws_instance" "akhq" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [var.sg_id]

  user_data = templatefile("${path.module}/user_data.sh", {
    bootstrap_servers = var.bootstrap_servers
  })

  tags = merge(var.tags, {
    Name = "akhq-monitoring"
  })
}