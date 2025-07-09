#!/bin/bash
set -e

NODE_COUNT=3

KEYSTORE_PASS="amitkeystorePassword"
TRUSTSTORE_PASS="amittruststorePassword"
KEY_PASS="amitkeysPassword"

for i in $(seq 1 $NODE_COUNT); do
    NODE_DIR="certs/kafka-${i}"
    mkdir -p "$NODE_DIR"
    echo "Generating certs for kafka-${i} in ${NODE_DIR}"

    # Set unique CN per node
    DNAME="CN=broker-${i}, OU=IT, O=kafka, L=BLR, ST=KA, C=IN"

    keytool -genkeypair \
        -alias kafka-${i} \
        -keyalg RSA \
        -keysize 2048 \
        -validity 365 \
        -storetype JKS \
        -keystore "$NODE_DIR/server.keystore.jks" \
        -storepass "$KEYSTORE_PASS" \
        -keypass "$KEY_PASS" \
        -dname "$DNAME"

    keytool -exportcert \
        -alias kafka-${i} \
        -keystore "$NODE_DIR/server.keystore.jks" \
        -storepass "$KEYSTORE_PASS" \
        -file "$NODE_DIR/kafka-${i}.crt" \
        -rfc

    keytool -importcert \
        -alias kafka-${i} \
        -file "$NODE_DIR/kafka-${i}.crt" \
        -storetype JKS \
        -keystore "$NODE_DIR/server.truststore.jks" \
        -storepass "$TRUSTSTORE_PASS" \
        -noprompt

    echo "Certificates for kafka-${i} generated successfully in ${NODE_DIR}"
done

echo "All certs generated successfully."
