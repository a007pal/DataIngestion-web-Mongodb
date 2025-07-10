#!/bin/bash
set -euo pipefail

KAFKA_VERSION="3.7.0"
BROKER_ID=${broker_id}
ZK_CONNECT="${zk_connect}"
SECRET_ID="kafka-tls-node-${BROKER_ID}"

# Step 1: Install dependencies
yum update -y
yum install -y java-1.8.0-openjdk wget unzip jq

# Step 2: Download Kafka
wget https://downloads.apache.org/kafka/${KAFKA_VERSION}/kafka_2.13-${KAFKA_VERSION}.tgz
mkdir -p /opt/kafka
tar -xzf kafka_2.13-${KAFKA_VERSION}.tgz -C /opt/kafka --strip-components 1

# Step 3: Create required dirs
mkdir -p /opt/kafka/secrets /opt/kafka/logs

# Step 4: Fetch certs from Secrets Manager
SECRET_JSON=$(aws secretsmanager get-secret-value --secret-id $SECRET_ID --query SecretString --output text)

echo "$SECRET_JSON" | jq -r .keystore_b64 | base64 -d > /opt/kafka/secrets/kafka.keystore.jks
echo "$SECRET_JSON" | jq -r .truststore_b64 | base64 -d > /opt/kafka/secrets/kafka.truststore.jks

KEYSTORE_PASS=$(echo "$SECRET_JSON" | jq -r .keystore_password)
TRUSTSTORE_PASS=$(echo "$SECRET_JSON" | jq -r .truststore_password)
KEY_PASS=$(echo "$SECRET_JSON" | jq -r .key_password)

# Step 5: Update server.properties
cat <<EOF > /opt/kafka/config/server.properties
broker.id=${BROKER_ID}
log.dirs=/opt/kafka/logs
zookeeper.connect=${ZK_CONNECT}

listeners=SSL://:9093
advertised.listeners=SSL://broker-${BROKER_ID}.internal:9093
listener.security.protocol.map=SSL:SSL
ssl.keystore.location=/opt/kafka/secrets/kafka.keystore.jks
ssl.keystore.password=$KEYSTORE_PASS
ssl.key.password=$KEY_PASS
ssl.truststore.location=/opt/kafka/secrets/kafka.truststore.jks
ssl.truststore.password=$TRUSTSTORE_PASS
security.inter.broker.protocol=SSL
ssl.client.auth=required
authorizer.class.name=kafka.security.authorizer.AclAuthorizer
super.users=User:CN=admin
allow.everyone.if.no.acl.found=false
EOF

# Step 6: Start Kafka
nohup /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties > /var/log/kafka.log 2>&1 &
