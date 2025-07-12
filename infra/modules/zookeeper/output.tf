output "zookeeper_private_ips" {
  value       = aws_instance.zookeeper[*].private_ip
  description = "Private IPs of Zookeeper nodes"
}

output "zookeeper_connection_string" {
  #value       = join(",", [for i in aws_instance.zookeeper : "${i.private_ip}:2181"])
  value = join(",", [for i in range(length(aws_instance.zookeeper)) : "zk-${i + 1}.prop.view.tracker.zookeeper.internal"])
  description = "Zookeeper connection string to be used by Kafka brokers"
}

output "zookeeper_instance_ids" {
  value       = aws_instance.zookeeper[*].id
  description = "Zookeeper EC2 instance IDs"
}