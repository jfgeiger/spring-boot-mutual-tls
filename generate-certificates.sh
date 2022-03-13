# Setup
rm src/main/resources/localhost.keystore
rm src/main/resources/localhost.truststore

CERTS_FOLDER=certificates
rm -rf "$CERTS_FOLDER"
mkdir -p "$CERTS_FOLDER"

# CA
openssl genrsa -out "$CERTS_FOLDER"/ca.key 4096
openssl req -x509 -new -nodes -key "$CERTS_FOLDER"/ca.key -sha256 -days 1024 -out "$CERTS_FOLDER"/ca.crt -subj "/CN=CA"

# Server
openssl genrsa -out "$CERTS_FOLDER"/localhost.key 4096
openssl req -new -sha256 -key "$CERTS_FOLDER"/localhost.key -subj "/CN=localhost" -out "$CERTS_FOLDER"/localhost.csr
openssl x509 -req -in "$CERTS_FOLDER"/localhost.csr -CA "$CERTS_FOLDER"/ca.crt -CAkey "$CERTS_FOLDER"/ca.key -CAcreateserial -out "$CERTS_FOLDER"/localhost.crt -days 500 -sha256

## Keystore
openssl pkcs12 -export -in "$CERTS_FOLDER"/localhost.crt -inkey "$CERTS_FOLDER"/localhost.key -out "$CERTS_FOLDER"/localhost.p12 -password pass:changeit -name "localhost"
keytool -importkeystore -srckeystore "$CERTS_FOLDER"/localhost.p12 -srcstoretype pkcs12 -srcstorepass changeit -destkeystore src/main/resources/localhost.keystore -deststorepass changeit

## Truststore
keytool -keystore src/main/resources/localhost.truststore -storepass changeit -import -trustcacerts -alias CA -noprompt -file "$CERTS_FOLDER"/ca.crt

# Client
openssl genrsa -out "$CERTS_FOLDER"/client.key 4096
openssl req -new -sha256 -key "$CERTS_FOLDER"/client.key -subj "/CN=client" -out "$CERTS_FOLDER"/client.csr
openssl x509 -req -in "$CERTS_FOLDER"/client.csr -CA "$CERTS_FOLDER"/ca.crt -CAkey "$CERTS_FOLDER"/ca.key -CAcreateserial -out "$CERTS_FOLDER"/client.crt -days 500 -sha256

# Unregistered Client
openssl genrsa -out "$CERTS_FOLDER"/unregistered-client.key 4096
openssl req -new -sha256 -key "$CERTS_FOLDER"/unregistered-client.key -subj "/CN=client-2" -out "$CERTS_FOLDER"/unregistered-client.csr
openssl x509 -req -in "$CERTS_FOLDER"/unregistered-client.csr -CA "$CERTS_FOLDER"/ca.crt -CAkey "$CERTS_FOLDER"/ca.key -CAcreateserial -out "$CERTS_FOLDER"/unregistered-client.crt -days 500 -sha256

# Malicious CA
openssl genrsa -out "$CERTS_FOLDER"/malicious-ca.key 4096
openssl req -x509 -new -nodes -key "$CERTS_FOLDER"/malicious-ca.key -sha256 -days 1024 -out "$CERTS_FOLDER"/malicious-ca.crt -subj "/CN=CA"

# Malicious client
openssl genrsa -out "$CERTS_FOLDER"/malicious-client.key 4096
openssl req -new -sha256 -key "$CERTS_FOLDER"/malicious-client.key -subj "/CN=client" -out "$CERTS_FOLDER"/malicious-client.csr
openssl x509 -req -in "$CERTS_FOLDER"/malicious-client.csr -CA "$CERTS_FOLDER"/malicious-ca.crt -CAkey "$CERTS_FOLDER"/malicious-ca.key -CAcreateserial -out "$CERTS_FOLDER"/malicious-client.crt -days 500 -sha256