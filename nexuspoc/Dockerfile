FROM sonatype/nexus3:latest
USER root
# Copy the user creation script
# COPY nexus-default.properties /opt/sonatype/nexus/etc/nexus-default.properties
COPY nexus-setup.sh /opt/sonatype/nexus-setup.sh
RUN chmod +x /opt/sonatype/nexus-setup.sh
# Expose Nexus port
EXPOSE 8081
# Define volumes for Nexus data and sonatype work directory
VOLUME /nexus-data /opt/sonatype-work
# Set working directory
WORKDIR /opt/sonatype/nexus
# Start Nexus
USER nexus
# Start Nexus and create user
ENTRYPOINT ["sh", "-c", "/opt/sonatype/nexus-setup.sh & exec bin/nexus run"]