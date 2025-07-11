#!/bin/bash
set -euo pipefail

ZOOKEEPER_VERSION="3.8.4"
NODE_ID=${NODE_ID}
SECRET_ID="zookeeper_tls_${NODE_ID}"

# Step 1: Install dependencies
yum update -y
yum install -y java-1.8.0-openjdk wget unzip jq

# Step 2: Download and extract Zookeeper
wget https://downloads.apache.org/zookeeper/zookeeper-$${ZOOKEEPER_VERSION}/apache-zookeeper-$${ZOOKEEPER_VERSION}-bin.tar.gz
mkdir -p /opt/zookeeper
tar -xzf apache-zookeeper-$${ZOOKEEPER_VERSION}-bin.tar.gz -C /opt/zookeeper --strip-components 1

# Step 3: Create data and secrets directories
mkdir -p /opt/zookeeper/data
mkdir -p /opt/zookeeper/secrets

# Step 4: Set myid file (used by ZooKeeper quorum)
echo "$NODE_ID" > /opt/zookeeper/data/myid

# Step 5: Fetch TLS certs from AWS Secrets Manager
SECRET_JSON=$(aws secretsmanager get-secret-value --secret-id $SECRET_ID --query SecretString --output text)

echo "$SECRET_JSON" | jq -r .keystore_b64 | base64 -d > /opt/zookeeper/secrets/server.keystore.jks
echo "$SECRET_JSON" | jq -r .truststore_b64 | base64 -d > /opt/zookeeper/secrets/server.truststore.jks

KEYSTORE_PASS=$(echo "$SECRET_JSON" | jq -r .keystore_password)
TRUSTSTORE_PASS=$(echo "$SECRET_JSON" | jq -r .truststore_password)
KEY_PASS=$(echo "$SECRET_JSON" | jq -r .key_password)

# Step 6: Generate zoo.cfg
cat <<EOF > /opt/zookeeper/conf/zoo.cfg
tickTime=2000
initLimit=5
syncLimit=2
dataDir=/opt/zookeeper/data
clientPort=0
secureClientPort=2281
serverCnxnFactory=org.apache.zookeeper.server.NettyServerCnxnFactory
ssl.keyStore.location=/opt/zookeeper/secrets/server.keystore.jks
ssl.keyStore.password=$KEYSTORE_PASS
ssl.trustStore.location=/opt/zookeeper/secrets/server.truststore.jks
ssl.trustStore.password=$TRUSTSTORE_PASS
ssl.clientAuth=need
EOF

echo "${server_list}" >> /opt/zookeeper/conf/zoo.cfg
# Step 8: Start ZooKeeper
nohup /opt/zookeeper/bin/zkServer.sh start > /var/log/zookeeper.log 2>&1 &
