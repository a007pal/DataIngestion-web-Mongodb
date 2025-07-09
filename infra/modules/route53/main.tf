resource "aws_route53_zone" "zookeper_route53_zone" {
  name = "${var.name_perfix}.zookeper.internal"
  vpc {
    vpc_id = var.vpc_id
  }
  tags = {
    Name = "${var.name_perfix}-zookeper-zone"
    Environment = var.environment
  }
}
resource "aws_route53_record" "zookeper_route53_record" {
    count = var.zookeeper_count
    zone_id = aws_route53_zone.zookeper_route53_zone.zone_id
    name = "zk-${count.index + 1}.internal"
    type = "A"
    ttl = 60
    records = [var.zookeeper_privvate_ips[count.index]]
  
}