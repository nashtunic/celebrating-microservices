#!/bin/bash

# Create SSL directory if it doesn't exist
mkdir -p /opt/celebrating-microservices/ssl

# Generate PKCS12 keystore for API Gateway
keytool -genkeypair \
  -alias api-gateway \
  -keyalg RSA \
  -keysize 2048 \
  -storetype PKCS12 \
  -keystore /opt/celebrating-microservices/ssl/api-gateway.p12 \
  -validity 3650 \
  -storepass celebrate123 \
  -dname "CN=Celebrating, OU=API Gateway, O=Celebrating, L=Nairobi, ST=Nairobi, C=KE" \
  -ext "SAN=IP:197.254.53.252"

# Export the certificate
keytool -export \
  -alias api-gateway \
  -keystore /opt/celebrating-microservices/ssl/api-gateway.p12 \
  -file /opt/celebrating-microservices/ssl/api-gateway.crt \
  -storepass celebrate123

echo "SSL certificates generated successfully" 