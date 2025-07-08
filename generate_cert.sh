#!/bin/bash
set -e

NODE_COUNT=3

KEYSTORE_PASS="amitkeystorePassword"
TRUSTSTORE_PASS="amittruststorePassword"
KEY_PASS="amitkeysPassword"

for i in $(seq 1 $NODE_COUNT); do
    NODE_DIR="certs/zookeeper-${i}"
    mkdir -p "$NODE_DIR"
    echo "Generating certs for zookeeper-${i} in ${NODE_DIR}"

    # Set unique CN per node
    DNAME="CN=zookeeper-${i}, OU=IT, O=ZooKeeper, L=BLR, ST=KA, C=IN"

    keytool -genkeypair \
        -alias zookeeper-${i} \
        -keyalg RSA \
        -keysize 2048 \
        -validity 365 \
        -storetype JKS \
        -keystore "$NODE_DIR/server.keystore.jks" \
        -storepass "$KEYSTORE_PASS" \
        -keypass "$KEY_PASS" \
        -dname "$DNAME"

    keytool -exportcert \
        -alias zookeeper-${i} \
        -keystore "$NODE_DIR/server.keystore.jks" \
        -storepass "$KEYSTORE_PASS" \
        -file "$NODE_DIR/zookeeper-${i}.crt" \
        -rfc

    keytool -importcert \
        -alias zookeeper-${i} \
        -file "$NODE_DIR/zookeeper-${i}.crt" \
        -storetype JKS \
        -keystore "$NODE_DIR/server.truststore.jks" \
        -storepass "$TRUSTSTORE_PASS" \
        -noprompt

    echo "Certificates for zookeeper-${i} generated successfully in ${NODE_DIR}"
done

echo "All certs generated successfully."
