output "zk_private_hosted_zone_id" {
  value       = aws_route53_zone.zk_private_zone.zone_id
  description = "ID of the private hosted zone for ZooKeeper"
}

output "zk_dns_names" {
  value = [
    for i in range(var.zookeeper_count) : "zk-${i + 1}.internal"
  ]
  description = "List of private DNS names for ZooKeeper nodes"
}

output "zk_private_ips" {
  value = [
    for instance in aws_instance.zookeeper : instance.private_ip
  ]
  description = "Private IP addresses of ZooKeeper nodes"
}

output "zk_dns_to_ip_map" {
  value = {
    for i in range(var.zookeeper_count) :
    "zk-${i + 1}.internal" => aws_instance.zookeeper[i].private_ip
  }
  description = "Map of ZooKeeper DNS names to their private IPs"
}
