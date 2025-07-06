#!/bin/bash
set -e
sudo yum update -y
sudo yum install -y java-1.8.0-openjdk wget unzip -y

# Download Kafka
wget https://downloads.apache.org/kafka/3.7.0/kafka_2.13-3.7.0.tgz
mkdir -p /opt/kafka && tar -xzf kafka_2.13-3.7.0.tgz -C /opt/kafka --strip-components 1

# TLS setup directory
mkdir -p /etc/kafka/secrets

# Retrieve TLS certs from Secrets Manager (assumes you stored base64 encoded files)
aws secretsmanager get-secret-value --secret-id kafka-keystore --query SecretString --output text | base64 -d > /etc/kafka/secrets/server.keystore.jks
aws secretsmanager get-secret-value --secret-id kafka-truststore --query SecretString --output text | base64 -d > /etc/kafka/secrets/server.truststore.jks

# Create config
cat <<EOF > /opt/kafka/config/server.properties
broker.id=${broker_id}
listeners=SSL://0.0.0.0:9093
advertised.listeners=SSL://$(hostname -i):9093
log.dirs=/tmp/kafka-logs
zookeeper.connect=${zookeeper_connect}
security.inter.broker.protocol=SSL
ssl.keystore.location=/etc/kafka/secrets/server.keystore.jks
ssl.keystore.password=${keystore_password}
ssl.truststore.location=/etc/kafka/secrets/server.truststore.jks
ssl.truststore.password=${truststore_password}
ssl.client.auth=required
min.insync.replicas=${min_insync_replicas}
offset.retention.minutes=10080
auto.leader.rebalance.enable=true
unclean.leader.election.enable=false
EOF

nohup /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties > /tmp/kafka.log 2>&1 &