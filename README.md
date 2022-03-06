Covid Metrics Dashboard in R
============================

1. Generates a dashboard with R and flexdashboard
2. Writes output to Azure blob storage

## The Container

```sh
AWS_KEY=< your AWS_KEY > 
AWS_SECRET=< your AWS_SECRET >
AWS_REGION=<your AWS_REGION >
AWS_BUCKET=<your AWS_BUCKET >
IMAGE_NAME=<your image name>
docker build --pull --rm -f "Dockerfile" -t ${IMAGE_NAME} --build-arg AWS_KEY=${AWS_KEY} --build-arg AWS_SECRET=${AWS_SECRET} --build-arg AWS_REGION=${AWS_REGION} --build-arg AWS_BUCKET=${AWS_BUCKET} .
```

The container can then be pushed to an AWS ECR and scheduled to run at a specific time, with Event Bridge.


