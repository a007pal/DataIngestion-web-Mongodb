resource "aws_security_group" "lambda" {
  name        = "${var.name_prefix}-lambda-sg"
  description = "Security group for Lambda TO Kafka"
  vpc_id      = aws_vpc.main.id
  tags        = var.tags
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "bastion_sg" {
  name        = "${var.name_prefix}-bastion-sg"
  description = "Allow SSH from developer machine"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr_bastion]
    description = "SSH from your IP"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-bastion-sg"
  }
}
# kafka security group
resource "aws_security_group" "kafka" {
  name        = "${var.name_prefix}-kafka-sg"
  description = "Security group for Lambda TO Kafka"
  vpc_id      = aws_vpc.main.id
  tags        = var.tags
  depends_on  = [aws_security_group.bastion_sg]
}
resource "aws_security_group_rule" "kafka_tls_client" {
  type              = "ingress"
  from_port         = 9093
  to_port           = 9093
  protocol          = "tcp"
  security_group_id = aws_security_group.kafka.id
  cidr_blocks       = var.vpc_cidr
  description       = "Secure Kafka TLS communication"

}
resource "aws_security_group_rule" "kafka_ssh_from_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.kafka.id
  source_security_group_id = aws_security_group.bastion_sg.id
  description              = "Allow SSH from bastion host"
}
resource "aws_security_group_rule" "kafka_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.kafka.id
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound"
}

# security group for zookeeper
resource "aws_security_group" "zookeeper" {
  name        = "${var.name_prefix}-zookeeper-sg"
  description = "Security group for Zookeeper"
  vpc_id      = aws_vpc.main.id
  tags        = var.tags
  depends_on  = [aws_security_group.bastion_sg]

}

resource "aws_security_group_rule" "zookeeper_tls_client" {
  type              = "ingress"
  from_port         = 2281
  to_port           = 2281
  protocol          = "tcp"
  security_group_id = aws_security_group.zookeeper.id
  cidr_blocks       = var.vpc_cidr
  description       = "Allow TLS client connections to Zookeeper"

}

resource "aws_security_group_rule" "zookeeper_quorum_communication" {
  type                     = "ingress"
  from_port                = 2888
  to_port                  = 2888
  protocol                 = "tcp"
  security_group_id        = aws_security_group.zookeeper.id
  source_security_group_id = aws_security_group.zookeeper.id
  description              = "Inter-node communication (ZooKeeper quorum)"

}
resource "aws_security_group_rule" "zookeeper_admin" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = aws_security_group.zookeeper.id
  cidr_blocks       = var.vpc_cidr
  description       = "ZooKeeper Admin HTTP Port (optional)"
}

resource "aws_security_group_rule" "zookeeper_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.zookeeper.id
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound"
}


resource "aws_security_group_rule" "zookeeper_ssh_from_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.zookeeper.id
  source_security_group_id = aws_security_group.bastion_sg.id
  description              = "Allow SSH from bastion host"
}
