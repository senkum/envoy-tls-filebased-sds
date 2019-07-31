#!/bin/bash

# Generate the certificate
/opt/generate-certificate.sh

# Start the service
python3 /opt/service.py &

# Create crontab and start cron
cat /opt/cronjob | crontab -
crond

exec envoy -c /opt/envoy.yaml --restart-epoch $RESTART_EPOCH  --service-cluster mycluster --service-node mycluster 
