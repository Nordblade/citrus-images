# ----------------------------------
# Citrusnode Custom Docker Image
# Image: ghcr.io/nordblade/citrus-images:java-jre16
# ----------------------------------

FROM        debian:bullseye-slim

LABEL       author="Citrusnode" maintainer="info@citrusnode.com"

RUN apt-get update -y \
 && apt-get install fontconfig iproute2 curl ca-certificates tar -y \
 && useradd -d /home/container -m container \
 && mkdir -p /opt/java


# Add Sparked certificate authority
ADD ca.crt /usr/local/share/ca-certificates/sparked-ca.crt
RUN chmod 644 /usr/local/share/ca-certificates/sparked-ca.crt && update-ca-certificates

# Set user that will run the entrypoint script, and overwrite USER, HOME and PATH environment variables
# We need to inject the path to the Java binaries in the PATH environment variable
USER container
ENV  USER=container HOME=/home/container PATH="$PATH:/opt/java/bin" LANG=C.UTF-8

WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh

CMD         ["/bin/bash", "/entrypoint.sh"]

