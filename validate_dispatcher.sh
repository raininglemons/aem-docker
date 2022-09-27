#!/bin/sh

# get dispatcher config path...
#
source ./.env

docker run --rm -v ${DISPATCHER_CONFIG}:/tmp/dispatcher:ro --entrypoint /bin/sh \
  --env AEM_HOST=localhost --env AEM_PORT=12345 --env DISP_LOG_LEVEL=Debug \
  aem-dispatcher:latest /docker_entrypoint.sh /opt/dispatcher/validate.sh

echo ${DISPATCHER_CONFIG}