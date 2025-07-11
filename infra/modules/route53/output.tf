output "zk_private_hosted_zone_id" {
  value       = aws_route53_zone.zookeper_route53_zone.id
  description = "ID of the private hosted zone for ZooKeeper"
}
output "broker_private_hosted_zone_id" {
  value       = aws_route53_zone.kafka_route53_zone.id
  description = "ID of the private hosted zone for ZooKeeper"
}

output "zk_dns_names" {
  value = [
    for i in range(var.zookeeper_count) : "zk-${i + 1}.internal"
  ]
  description = "List of private DNS names for ZooKeeper nodes"
}
output "zk_dns_zone_name" {
  value       = aws_route53_zone.zookeper_route53_zone.name
  description = "Name of the private hosted zone for ZooKeeper"
}
