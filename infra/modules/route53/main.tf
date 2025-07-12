resource "aws_route53_zone" "zookeper_route53_zone" {
  name = "${var.name_perfix}.zookeeper.internal"
  vpc {
    vpc_id = var.vpc_id
  }
  tags = {
    Name = "${var.name_perfix}-zookeeper-zone"
    Environment = var.environment
  }
}
resource "aws_route53_record" "zookeper_route53_record" {
    count = var.zookeeper_count
    zone_id = aws_route53_zone.zookeper_route53_zone.zone_id
    name = "zk-${count.index + 1}"
    type = "A"
    ttl = 60
    records = [var.zookeeper_private_ips[count.index]]
  
}

resource "aws_route53_zone" "kafka_route53_zone" {
  name = "${var.name_perfix}.kafka.internal"
  vpc {
    vpc_id = var.vpc_id
  }
  tags = {
    Name = "${var.name_perfix}-kafka-zone"
    Environment = var.environment
  }
}
resource "aws_route53_record" "kafka_route53_record" {
    count = var.kafka_count
    zone_id = aws_route53_zone.kafka_route53_zone.zone_id
    name = "broker-${count.index + 1}"
    type = "A"
    ttl = 60
    records = [var.kafka_private_ips[count.index]]
  
}