# Use the official SonarQube image as the base
FROM sonarqube:community
# Set environment variables for SonarQube
ENV SONARQUBE_HOME=/opt/sonarqube \
    PATH=$PATH:/opt/sonarqube/bin
# Set the working directory
WORKDIR $SONARQUBE_HOME
# Temporarily switch to root to update permissions
USER root
# Copy the custom script to update the password
COPY update-password.sh /opt/sonarqube/update-password.sh
COPY start-sonarqube.sh /opt/sonarqube/start-sonarqube.sh
# Ensure the script is executable
RUN chmod +x /opt/sonarqube/update-password.sh /opt/sonarqube/start-sonarqube.sh
# Switch back to the default SonarQube user
USER sonarqube
# Expose the default SonarQube port
EXPOSE 9000
# Set entrypoint to start SonarQube
ENTRYPOINT ["/bin/bash","-c","/opt/sonarqube/docker/entrypoint.sh & /opt/sonarqube/start-sonarqube.sh && tail -f /dev/null"]
# Default command
CMD ["console"]









