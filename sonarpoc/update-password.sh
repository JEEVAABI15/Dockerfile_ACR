#!/bin/bash
# Variables
SONARQUBE_URL="http://localhost:9000"
OLD_PASSWORD="admin"
NEW_PASSWORD="Guha@6542060"
MAX_RETRIES=30
RETRY_COUNT=0
echo "Waiting for SonarQube to be ready..."
# Wait for SonarQube to become ready
while ! curl -u admin:${OLD_PASSWORD} -s "${SONARQUBE_URL}/api/system/health" | grep -q '"health":"GREEN"'; do
    sleep 5
    RETRY_COUNT=$((RETRY_COUNT + 1))
    echo "Still waiting for SonarQube... Attempt $RETRY_COUNT"
    if [ $RETRY_COUNT -ge $MAX_RETRIES ]; then
        echo "SonarQube did not become ready in time. Please check the logs."
        exit 1
    fi
done
echo "SonarQube is up and running. Proceeding with password update..."
# Update admin password
PASSWORD_UPDATE_RESPONSE=$(curl -u admin:${OLD_PASSWORD} -s -o /dev/null -w "%{http_code}" -X POST \
  "${SONARQUBE_URL}/api/users/change_password" \
  -d "login=admin&password=${NEW_PASSWORD}&previousPassword=${OLD_PASSWORD}")
if [ "$PASSWORD_UPDATE_RESPONSE" -eq 204 ]; then
    echo "Password updated successfully to: ${NEW_PASSWORD}"
else
    echo "Failed to update the password. Please check your configuration."
    exit 1
fi