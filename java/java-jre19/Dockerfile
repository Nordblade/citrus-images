# ----------------------------------
# Citrusnode Custom Docker Image
# Image: ghcr.io/nordblade/citrus-images:java-jre19
# ----------------------------------

# Use Alpine Linux as the base image
FROM alpine:3.13

LABEL author="Citrusnode" maintainer="info@citrusnode.com"

RUN apk add --no-cache fontconfig curl ca-certificates tar \
 && adduser -D -h /home/container container \
 && mkdir -p /opt/java

# Download a specific version of the JRE
ADD https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19.0.2%2B7/OpenJDK19U-jre_x64_linux_hotspot_19.0.2_7.tar.gz /opt/java/java.tar.gz
RUN tar -C /opt/java --strip-components=1 -xzf /opt/java/java.tar.gz \
 && rm -f /opt/java/java.tar.gz

# Add Sparked certificate authority
ADD ca.crt /usr/local/share/ca-certificates/sparked-ca.crt
RUN chmod 644 /usr/local/share/ca-certificates/sparked-ca.crt && update-ca-certificates

# Set user that will run the entrypoint script, and overwrite USER, HOME, and PATH environment variables
# Inject the path to the Java binaries in the PATH environment variable
USER container
ENV USER=container HOME=/home/container PATH="/opt/java/bin:$PATH" LANG=C.UTF-8

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]

