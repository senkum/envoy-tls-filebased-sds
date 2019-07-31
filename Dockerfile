FROM envoyproxy/envoy-alpine

RUN apk update && apk add python3 bash curl openssl
RUN pip3 install --upgrade pip
RUN pip3 install -q Flask==0.11.1 requests==2.18.4

WORKDIR /opt/

COPY cronjob /opt/cronjob

COPY generate-certificate.sh /opt/generate-certificate.sh
RUN chmod u+x /opt/generate-certificate.sh

COPY renew-certificate.sh /opt/renew-certificate.sh
RUN chmod u+x /opt/renew-certificate.sh

COPY envoy.yaml /opt/envoy.yaml
COPY envoy-secret-template.yaml /opt/envoy-secret-template.yaml

COPY startup.sh /opt/startup.sh
RUN chmod u+x /opt/startup.sh

RUN mkdir /opt/certs

COPY service.py /opt/service.py 

ENTRYPOINT /opt/startup.sh
