#!/bin/bash
set -e
sudo yum update -y
sudo yum install -y java-1.8.0-openjdk wget unzip -y

wget https://downloads.apache.org/zookeeper/zookeeper-3.8.4/apache-zookeeper-3.8.4-bin.tar.gz
mkdir -p /opt/zookeeper && tar -xzf apache-zookeeper-3.8.4-bin.tar.gz -C /opt/zookeeper --strip-components 1

mkdir -p /opt/zookeeper/data
mkdir -p /opt/zookeeper/secrets

# Set myid
echo "${myid}" > /opt/zookeeper/data/myid

# Retrieve TLS certs from Secrets Manager
aws secretsmanager get-secret-value --secret-id kafka-keystore --query SecretString --output text | base64 -d > /opt/zookeeper/secrets/server.keystore.jks
aws secretsmanager get-secret-value --secret-id kafka-truststore --query SecretString --output text | base64 -d > /opt/zookeeper/secrets/server.truststore.jks

# Generate config
cat <<EOF > /opt/zookeeper/conf/zoo.cfg
tickTime=2000
dataDir=/opt/zookeeper/data
clientPort=2181
secureClientPort=2281
serverCnxnFactory=org.apache.zookeeper.server.NettyServerCnxnFactory
ssl.keyStore.location=/opt/zookeeper/secrets/server.keystore.jks
ssl.keyStore.password=${keystore_password}
ssl.trustStore.location=/opt/zookeeper/secrets/server.truststore.jks
ssl.trustStore.password=${truststore_password}
ssl.clientAuth=need
initLimit=5
syncLimit=2
${servers}
EOF

nohup /opt/zookeeper/bin/zkServer.sh start > /tmp/zookeeper.log 2>&1 &