resource "aws_instance" "zookeeper" {
  count                  = var.zookeeper_count
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
    Name        = "zk-${count.index + 1}"
    Role        = "zookeeper"
    Environment = var.environment
  }

  user_data = templatefile("${path.module}/user_data.sh", {
    NODE_ID = count.index + 1
    server_list = join("\n", [
      for i in range(var.zookeeper_count) :
      "server.${i + 1}=zk-${i + 1}.prop.view.tracker.zookeeper.internal:2888:3888"
    ])
    host_list = join(",", [
      for i in range(var.zookeeper_count) :
      "zk-${i + 1}.prop.view.tracker.zookeeper.internal"
    ])
    AWS_REGION = var.region
  })
}
