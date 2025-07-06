resource "aws_instance" "schema_registry" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [var.sg_id]

  user_data = templatefile("${path.module}/user_data.sh", {
    bootstrap_servers     = var.bootstrap_servers
    keystore_password     = var.keystore_password
    truststore_password   = var.truststore_password
  })

  tags = merge(var.tags, {
    Name = "schema-registry"
  })
}