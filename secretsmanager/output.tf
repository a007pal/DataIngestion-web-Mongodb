output "zk_tls_secret_names" {
  value = [for s in aws_secretsmanager_secret.zk_tls : s.name]
}