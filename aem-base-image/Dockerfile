# Based initially on: http://digitalvarys.com/create-aem-in-docker-with-docker-compose/#Creating_Base_Image
# Using 'ubuntu' as the base image here
FROM ubuntu:22.04

# setting the working directory
WORKDIR /opt/aem

# Copy Quickstart jar file
COPY cq-quickstart.jar cq-quickstart.jar

# Copy charles root certificate
COPY charles-ssl-proxying-certificate.crt /usr/local/share/ca-certificates/charles-ssl-proxying-certificate.crt

# Install Java
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:openjdk-r/ppa && \
    apt-get update && \
    apt-get install -y openjdk-11-jdk && \
#    apt-get install -y openjdk-11-jdk=11.0.13+8-0ubuntu1~21.10 && \
#    apt-get install -y openjdk-11-jdk=11.0.10+9-LTS && \
    apt-get install -y ca-certificates

RUN update-ca-certificates
# Unpack the Jar file
# RUN java -jar cq-quickstart.jar -unpack

# Copy packages
COPY packages /opt/aem/packages