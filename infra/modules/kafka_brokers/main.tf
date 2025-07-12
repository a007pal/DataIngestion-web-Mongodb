resource "aws_instance" "kafka" {
  count                  = var.broker_count
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[count.index % length(var.subnet_ids)]
  key_name               = var.key_name
  vpc_security_group_ids = [var.sg_id]
  iam_instance_profile   = var.profile_name
  private_dns_name_options {
    enable_resource_name_dns_a_record = true
    hostname_type                     = "ip-name"
  }
  tags = {
    Name        = "kafka-${count.index + 1}"
    Role        = "kafka"
    Environment = var.environment
  }

  user_data = templatefile("${path.module}/user_data.sh", {
    broker_id    = count.index + 1
    zk_connect   = var.zookeeper_connection_string
    AWS_REGION      = var.region
  })
}
