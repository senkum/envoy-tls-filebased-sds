#!/bin/bash

# Generate certificate
number=`(shuf -i 1-1000 -n 1)`
echo "Generating Certificate "$number

rm /opt/certs/*

openssl req -new -newkey rsa:2048 -nodes -x509 -out /opt/certs/demo$number.crt -keyout /opt/certs/demo$number.key -subj '/emailAddress=senkum@sk.com/C=US/ST=CA/L=SJ/O=SK/OU=Dev/CN=SK'$number

cat > /opt/envoy-secret-new.yaml <<EOF
version_info: "0"
resources:
- '@type': type.googleapis.com/envoy.api.v2.auth.Secret
  name: server-cert-and-key
  tls_certificate:
    certificate_chain:
      filename: /opt/certs/demo$number.crt
    private_key:
      filename: /opt/certs/demo$number.key
EOF

mv /opt/envoy-secret-new.yaml /opt/envoy-secret.yaml
