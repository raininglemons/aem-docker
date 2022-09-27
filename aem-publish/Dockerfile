# Use the previously created aem-base-image
FROM aem-base-image

# Expose AEM Publisher in port 4503
EXPOSE 4503

# No longer needed now we provide run modes in launch context.
# RUN mv ./cq-quickstart.jar ./aem-publish-p4503.jar

COPY start.sh start.sh
RUN chmod +x ./start.sh

ENTRYPOINT ["./start.sh"]