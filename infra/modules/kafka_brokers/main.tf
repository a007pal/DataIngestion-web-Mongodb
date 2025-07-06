resource "aws_instance" "kafka" {
  count         = var.broker_count
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_ids[count.index % length(var.subnet_ids)]
  key_name      = var.key_name
  vpc_security_group_ids = [var.sg_id]

  user_data = templatefile("${path.module}/user_data.sh", {
    broker_id           = count.index + 1
    zookeeper_connect   = var.zookeeper_connect
    keystore_password   = var.keystore_password
    truststore_password = var.truststore_password
    min_insync_replicas = var.min_insync_replicas
  })

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-broker-${count.index + 1}"
  })
}