#!/bin/sh
# Wait for SonarQube to be ready
echo "Waiting for SonarQube to be ready..."
until curl -u admin:admin -s http://localhost:9000/api/system/health | grep -q '"health":"GREEN"'; do
  echo "Still waiting for SonarQube..."
  sleep 5
done
echo "SonarQube is up. Running password update script..."
/opt/sonarqube/update-password.sh
# Keep the container running
wait