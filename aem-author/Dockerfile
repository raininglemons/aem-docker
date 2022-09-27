# Use the previously created aem-base-image
FROM aem-base-image

# Expose AEM author in port 4502
EXPOSE 4502

# No longer needed now we provide run modes in launch context.
# RUN mv ./cq-quickstart.jar ./aem-author-p4502.jar

COPY start.sh start.sh
RUN chmod +x ./start.sh

ENTRYPOINT ["./start.sh"]