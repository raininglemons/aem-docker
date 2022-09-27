#!/bin/sh

#
# Generate a new SSL certificate on start so we don't have to worry about cert expiry
#
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout ./docker.key \
  -out ./docker.crt -config ./docker.conf \
  -subj "/C=GB/ST=London/L=London/O=Raininglemons/OU=Dev/CN=aemsite.dev"