# ----------------------------------
# Citrusnode Custom Docker Image
# Image: ghcr.io/nordblade/citrus-images:java-jre11
# ----------------------------------

# Use Alpine Linux as the base image
FROM alpine:3.13

LABEL author="Citrusnode" maintainer="info@citrusnode.com"

RUN apk add --no-cache \
 && adduser -D -h /home/container container \
 && mkdir -p /opt/java

# Add Sparked certificate authority
ADD ca.crt /usr/local/share/ca-certificates/sparked-ca.crt
RUN chmod 644 /usr/local/share/ca-certificates/sparked-ca.crt && update-ca-certificates

# Set user that will run the entrypoint script, and overwrite USER, HOME, and PATH environment variables
USER container
ENV USER=container HOME=/home/container PATH="/opt/java/bin:$PATH" LANG=C.UTF-8

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]


