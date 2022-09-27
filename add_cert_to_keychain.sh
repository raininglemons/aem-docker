#!/bin/sh

sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ./aem-nginx/docker.crt