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

resource "aws_security_group" "kafka" {
  name        = "${var.name_prefix}-kafka-sg"
  description = "Security group for Lambda TO Kafka"
  vpc_id      = aws_vpc.main.id
  tags        = var.tags
  ingress {
    from_port       = 9093
    to_port         = 9093
    protocol        = "tcp"
    security_groups = [aws_security_group.lambda.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# security group for zookeeper
resource "aws_security_group" "zookeeper" {
  name        = "${var.name_prefix}-zookeeper-sg"
  description = "Security group for Zookeeper"
  vpc_id      = aws_vpc.main.id
  tags        = var.tags

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