resource "aws_secretsmanager_secret" "zk_tls" {
  count = var.zk_instance_count
  name  = "${var.name_prefix}-${var.zookeer_secret_name_prefix}-${count.index + 1}"
  tags = {
    Name : "${var.name_prefix}-${var.zookeer_secret_name_prefix}-${count.index + 1}"
    Environment : var.environment
  }
}

resource "aws_secretsmanager_secret_version" "zk_tls_version" {
  count     = var.zk_instance_count
  secret_id = aws_secretsmanager_secret.zk_tls[count.index].id
  secret_string = jsonencode({
    keystore_b64        = filebase64("${var.certs_path}-${count.index + 1}/server.keystore.jks")
    truststore_b64      = filebase64("${var.certs_path}-${count.index + 1}/server.truststore.jks")
    keystore_password   = "amitkeystorePassword"
    truststore_password = "amittruststorePassword"
    key_password="amitkeysPassword"
  })

}
