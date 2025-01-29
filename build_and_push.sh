#!/bin/bash

# Variables for resource group and ACR name
RESOURCE_GROUP="rithi0303-rg"
ACR_NAME="mycontainereg002"
LOCATION="EastUS2"  

# Ensure that the Azure CLI is logged in
echo "Logging into Azure..."
az login

# Check if the ACR exists, if not, create it
echo "Checking if Azure Container Registry exists..."
az acr show --name $ACR_NAME --resource-group $RESOURCE_GROUP &>/dev/null

if [ $? -ne 0 ]; then
    echo "ACR does not exist. Creating Azure Container Registry..."
    az acr create --resource-group $RESOURCE_GROUP --name $ACR_NAME --sku Standard --location $LOCATION
    sleep 12 # Sleep for 12 seconds to allow the ACR to be created
else
    echo "ACR already exists. Skipping creation."
fi

# Log in to ACR
echo "Logging into Azure Container Registry..."
az acr login --name $ACR_NAME

# ACR registry details
ACR_URL="$ACR_NAME.azurecr.io"

# List of image folders and their respective image names
declare -A images=(
    ["jenkins"]="jenkins"
    ["nexuspoc"]="nexus"
    ["sonarpoc"]="sonarqube"
)

# Build and push each image
for folder in "${!images[@]}"; do
    echo "Building Docker image for ${images[$folder]}..."
    
    # Navigate into the folder
    cd $folder
    
    # Build the Docker image
    docker build -t $ACR_URL/${images[$folder]}:v1 .
    
    # Push the image to ACR
    echo "Pushing ${images[$folder]} to ACR..."
    docker push $ACR_URL/${images[$folder]}:v1
    
    # Return to the root folder
    cd ..
    
    echo "${images[$folder]} image pushed successfully!"
done

# List all repositories in the ACR
echo "Listing repositories in Azure Container Registry..."
az acr repository list --name $ACR_NAME --output table

echo "All images have been built, pushed, and the repositories have been listed successfully."
