#!/bin/bash
set -e
sudo yum update -y
sudo yum install -y docker git
sudo systemctl start docker && sudo systemctl enable docker

# Create config
mkdir -p /opt/akhq/config
cat <<EOF > /opt/akhq/config/application.yml
akhq:
  server:
    servlet:
      context-path: /
    port: 8080
  connections:
    kafka-cluster:
      properties:
        bootstrap.servers: ${bootstrap_servers}
      schema-registry:
        url: "https://localhost:8081"
EOF

# Run AKHQ container
sudo docker run -d --restart=always \
  -v /opt/akhq/config:/app/config \
  -p 8080:8080 \
  -e "JAVA_OPTS=-Dlogback.configurationFile=logback.xml" \
  tchiotludo/akhq