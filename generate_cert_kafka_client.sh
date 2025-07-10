#!/bin/bash
set -e

CLIENTS=("admin" "producer-client" "consumer-client")

KEYSTORE_PASS="amit2748clientKeystore"
TRUSTSTORE_PASS="amit2748clientTruststore"
KEY_PASS="amit2748clientKeyPass"

for CLIENT in "${CLIENTS[@]}"; do
    CLIENT_DIR="certs/clients/${CLIENT}"
    mkdir -p "$CLIENT_DIR"
    echo "Generating TLS cert for client: $CLIENT"

    DNAME="CN=${CLIENT}, OU=Clients, O=Kafka, L=BLR, ST=KA, C=IN"

    # Generate Keystore
    keytool -genkeypair \
        -alias ${CLIENT} \
        -keyalg RSA \
        -keysize 2048 \
        -validity 365 \
        -storetype JKS \
        -keystore "$CLIENT_DIR/client.keystore.jks" \
        -storepass "$KEYSTORE_PASS" \
        -keypass "$KEY_PASS" \
        -dname "$DNAME"

    # Export cert
    keytool -exportcert \
        -alias ${CLIENT} \
        -keystore "$CLIENT_DIR/client.keystore.jks" \
        -storepass "$KEYSTORE_PASS" \
        -file "$CLIENT_DIR/${CLIENT}.crt" \
        -rfc

    # Import cert into truststore (trust self for now)
    keytool -importcert \
        -alias ${CLIENT} \
        -file "$CLIENT_DIR/${CLIENT}.crt" \
        -storetype JKS \
        -keystore "$CLIENT_DIR/client.truststore.jks" \
        -storepass "$TRUSTSTORE_PASS" \
        -noprompt

    echo "TLS certs created in: $CLIENT_DIR"
done

echo "All client certs generated successfully."
