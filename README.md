Covid Metrics Dashboard in R
============================

1. Generates a dashboard with R and flexdashboard
2. Writes output to Azure blob storage

## The Container

```sh
AZURE_STORAGE_ACCOUNT=<your storage account>
AZURE_STORAGE_KEY=<your storage key>
IMAGE_NAME=<your image name>
docker build --pull --rm -f "Dockerfile" -t ${IMAGE_NAME} --build-arg AZURE_STORAGE_ACCOUNT=${AZURE_STORAGE_ACCOUNT} --build-arg AZURE_STORAGE_KEY=${AZURE_STORAGE_KEY} .
```

The container can then be pushed to an Azure Container Registry and with an Azure Container Registry Task, scheduled to run at a specific time.


