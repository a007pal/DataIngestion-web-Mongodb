resource "aws_iam_role" "zookeeper_ec2" {
  name = "zookeeper_ec2_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

}

resource "aws_iam_role_policy" "zookeeper_secert_policy" {
  name = "zookeeper_secret_policy"
  role = aws_iam_role.zookeeper_ec2.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })

}
resource "aws_iam_instance_profile" "zookeeper_profile" {
  name = "zk-instance-profile"
  role = aws_iam_role.zookeeper_ec2.name

}
resource "aws_instance" "zookeeper" {
  count                  = var.zookeeper_count
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[count.index % length(var.subnet_ids)]
  key_name               = var.key_name
  vpc_security_group_ids = [var.sg_id]
  iam_instance_profile   = aws_iam_instance_profile.zookeeper_profile.name
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
    myid        = count.index + 1
    server_list = join(",", [for i in range(var.zookeeper_count) : "server.${i + 1}=${aws_instance.zookeeper[i].private_ip}:2888:3888"])
  })
}
