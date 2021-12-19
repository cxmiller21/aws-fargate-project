ECR_REPO=""
ECR_IMAGE="aws-fargate-project"
ECR_IMAGE_TAG="frontend"

DOCKER_TAG="$ECR_REPO/$ECR_IMAGE:$ECR_IMAGE_TAG"
echo "Pushing Docker image '$DOCKER_TAG' to ECR"

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_REPO
docker build -t $DOCKER_TAG .
docker push $DOCKER_TAG
