AWS_ACCOUNT_ID=""
ECR_REPO="$AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com"
DOCKER_TAG="$ECR_REPO/aws-fargate-project-server:latest"

echo "Pushing Docker image '$DOCKER_TAG' to ECR"

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_REPO
docker build -t $DOCKER_TAG .
docker push $DOCKER_TAG
