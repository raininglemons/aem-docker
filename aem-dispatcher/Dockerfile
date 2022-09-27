FROM adobe/aem-ethos/dispatcher-publish:latest

COPY 05-symlink-local-config.sh /docker_entrypoint.d/05-symlink-local-config.sh
RUN chmod +x /docker_entrypoint.d/05-symlink-local-config.sh

# Temporary workaround to disable mod_qos and configure Mutex to use a temp directory
# COPY 06-m1-workaround.sh /docker_entrypoint.d/06-m1-workaround.sh
# RUN chmod +x /docker_entrypoint.d/06-m1-workaround.sh

# Copy over the local dispatcher tools to the image so we can remotely execute the validator
# scripts regardless of host platform
COPY dispatcher /opt/dispatcher
RUN chmod +x /opt/dispatcher/validate.sh
WORKDIR /opt/dispatcher
RUN ./installer.sh
