# Custom Docker Images for Jenkins, Nexus, and SonarQube

This project provides Dockerfiles to build customized images for Jenkins, Nexus, and SonarQube, and push them to an **Azure Container Registry (ACR)**.

## Prerequisites
Before you begin, ensure you have the following installed:
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- Docker
- A valid Azure subscription

## Step 1: Login to Azure
```sh
az login
```

## Step 2: Create an Azure Container Registry (ACR)
```sh
az acr create --resource-group <RESOURCE_GROUP> --name <ACR_NAME> --sku Basic --admin-enabled true
```
Retrieve the ACR login server:
```sh
ACR_LOGIN_SERVER=$(az acr show --name <ACR_NAME> --query loginServer --output tsv)
```
Login to ACR:
```sh
docker login $ACR_LOGIN_SERVER -u $(az acr credential show --name <ACR_NAME> --query username --output tsv) -p $(az acr credential show --name <ACR_NAME> --query passwords[0].value --output tsv)
```

## Step 3: Build and Push Jenkins Image
```sh
docker build -t $ACR_LOGIN_SERVER/jenkins:latest -f jenkins/Dockerfile .
docker push $ACR_LOGIN_SERVER/jenkins:latest
```

## Step 4: Build and Push Nexus Image
```sh
docker build -t $ACR_LOGIN_SERVER/nexus:latest -f nexuspoc/Dockerfile .
docker push $ACR_LOGIN_SERVER/nexus:latest
```

## Step 5: Build and Push SonarQube Image
```sh
docker build -t $ACR_LOGIN_SERVER/sonarqube:latest -f sonarqubepoc/Dockerfile .
docker push $ACR_LOGIN_SERVER/sonarqube:latest
```

## Summary
This process builds **Jenkins, Nexus, and SonarQube** Docker images from their respective Dockerfiles and pushes them to **Azure Container Registry (ACR)** for further deployment via Helm charts or Kubernetes. Ensure all configurations are correctly set for optimized security and performance.

