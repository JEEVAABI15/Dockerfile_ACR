# CI/CD Pipeline for Jenkins, Nexus, and SonarQube with Azure Container Registry (ACR)

This document provides a step-by-step guide to setting up Jenkins, Nexus, and SonarQube in a DevOps pipeline. The focus is on using **Dockerfiles** to build customized images and pushing them to **Azure Container Registry (ACR)** for deployment in **Azure Kubernetes Service (AKS)**.

## Prerequisites

- **Azure CLI** installed ([Install Guide](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli))
- **Docker** installed ([Install Guide](https://docs.docker.com/get-docker/))
- **kubectl** installed ([Install Guide](https://kubernetes.io/docs/tasks/tools/install-kubectl/))
- **Helm** installed ([Install Guide](https://helm.sh/docs/intro/install/))
- An **Azure subscription**
- **AKS Cluster** created and configured

## Step 1: Set Up Azure Container Registry (ACR)

1. **Login to Azure**:
   ```sh
   az login
   ```
2. **Set subscription (if you have multiple subscriptions)**:
   ```sh
   az account set --subscription "<SUBSCRIPTION_ID>"
   ```
3. **Create an Azure Resource Group**:
   ```sh
   az group create --name DevOps-RG --location eastus
   ```
4. **Create an Azure Container Registry (ACR)**:
   ```sh
   az acr create --resource-group DevOps-RG --name DevOpsACR --sku Basic
   ```
5. **Enable Admin Access for ACR**:
   ```sh
   az acr update --name DevOpsACR --admin-enabled true
   ```
6. **Login to ACR**:
   ```sh
   az acr login --name DevOpsACR
   ```

## Step 2: Build and Push Docker Images to ACR

### Jenkins Image
```sh
cd jenkins/
docker build -t devopsacr.azurecr.io/jenkins:latest .
docker push devopsacr.azurecr.io/jenkins:latest
```

### Nexus Image
```sh
cd nexuspoc/
docker build -t devopsacr.azurecr.io/nexus:latest .
docker push devopsacr.azurecr.io/nexus:latest
```

### SonarQube Image
```sh
cd sonarqubepoc/
docker build -t devopsacr.azurecr.io/sonarqube:latest .
docker push devopsacr.azurecr.io/sonarqube:latest
```

## Step 3: Deploy to AKS using Helm

1. **Get AKS Credentials**:
   ```sh
   az aks get-credentials --resource-group DevOps-RG --name MyAKSCluster
   ```
2. **Deploy Jenkins**:
   ```sh
   helm install jenkins ./helm/jenkins --set image.repository=devopsacr.azurecr.io/jenkins,image.tag=latest
   ```
3. **Deploy Nexus**:
   ```sh
   helm install nexus ./helm/nexus --set image.repository=devopsacr.azurecr.io/nexus,image.tag=latest
   ```
4. **Deploy SonarQube**:
   ```sh
   helm install sonarqube ./helm/sonarqube --set image.repository=devopsacr.azurecr.io/sonarqube,image.tag=latest
   ```

## Step 4: Verify Deployment

1. **Check running pods**:
   ```sh
   kubectl get pods -n default
   ```
2. **Check services and expose**:
   ```sh
   kubectl get svc -n default
   ```
3. **Access Jenkins**:
   ```sh
   kubectl port-forward svc/jenkins 8080:8080
   ```
4. **Access Nexus**:
   ```sh
   kubectl port-forward svc/nexus 8081:8081
   ```
5. **Access SonarQube**:
   ```sh
   kubectl port-forward svc/sonarqube 9000:9000
   ```

## Step 5: Cleanup (Optional)

To delete the deployments and free up resources:
```sh
helm uninstall jenkins
helm uninstall nexus
helm uninstall sonarqube
az acr delete --name DevOpsACR --resource-group DevOps-RG --yes
az group delete --name DevOps-RG --yes
```

## Conclusion

This guide provides a complete **CI/CD workflow** for Jenkins, Nexus, and SonarQube, using **Docker**, **ACR**, and **AKS**. The images are built and pushed to **ACR**, and then deployed using **Helm charts**. This setup ensures a **scalable, cloud-native DevOps environment** for application development and security analysis.

