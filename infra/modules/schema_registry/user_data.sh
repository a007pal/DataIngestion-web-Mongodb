#!/bin/bash
set -e
sudo yum update -y
sudo yum install -y java-1.8.0-openjdk wget unzip -y

wget https://packages.confluent.io/archive/7.6/confluent-community-7.6.0.tar.gz
mkdir -p /opt/confluent && tar -xzf confluent-community-7.6.0.tar.gz -C /opt/confluent --strip-components 1

mkdir -p /opt/confluent/secrets

# Download certs
aws secretsmanager get-secret-value --secret-id kafka-keystore --query SecretString --output text | base64 -d > /opt/confluent/secrets/schema-registry.keystore.jks
aws secretsmanager get-secret-value --secret-id kafka-truststore --query SecretString --output text | base64 -d > /opt/confluent/secrets/schema-registry.truststore.jks

# Config
cat <<EOF > /opt/confluent/etc/schema-registry/schema-registry.properties
listeners=https://0.0.0.0:8081
kafkastore.bootstrap.servers=${bootstrap_servers}
kafkastore.security.protocol=SSL
kafkastore.ssl.truststore.location=/opt/confluent/secrets/schema-registry.truststore.jks
kafkastore.ssl.truststore.password=${truststore_password}
kafkastore.ssl.keystore.location=/opt/confluent/secrets/schema-registry.keystore.jks
kafkastore.ssl.keystore.password=${keystore_password}
kafkastore.ssl.key.password=${keystore_password}
EOF

nohup /opt/confluent/bin/schema-registry-start /opt/confluent/etc/schema-registry/schema-registry.properties > /tmp/schema-registry.log 2>&1 &
