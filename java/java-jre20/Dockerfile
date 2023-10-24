# ----------------------------------
# Citrusnode Custom Docker Image
# Image: ghcr.io/nordblade/citrus-images:java-jre20
# ----------------------------------

# Use a minimal base image
FROM alpine:latest

LABEL author="Citrusnode" maintainer="info@citrusnode.com"

# Install required packages
RUN apk update && apk add --no-cache openjdk11-jre-headless

# Set user that will run the entrypoint script
RUN adduser -D -h /home/container container
USER container

# Set the working directory
WORKDIR /home/container

# Copy the entrypoint script
COPY ./entrypoint.sh /entrypoint.sh

# Expose any necessary ports
EXPOSE 25565

CMD ["/bin/ash", "/entrypoint.sh"]


