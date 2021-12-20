# Infrastructure

Run AWS Fargate containers that are described in the client and server folders

### Startup

```
# 1. Create the Image Registries
$ terraform apply -target="aws_ecr_repository.main"

# 2. Build and push the server node image to ECR (root server folder run "$ npm run push:image")
# 3. Create the main ECS infrastructure and node fargate server
$ terraform apply

# 4. Get the Public IP address of the node task
# 5. Update the /client/src/components/NodeCall.vue "fargateNodeIP" variable and run "$ npm run push:image" in the root client folder
# 6. After the image is pushed, set the client.tf "node_task_ip_address_updated" variable to true and run a final apply
# Optionally run "$ curl public_ip:3000/getData" to test the server is working properly
$ terraform apply

# 7. Visit the vue-client tasks Public IP address and you should see the vue app with a message from the node server!
```

## Deployment

### AWS Resources Created

* ECS Fargate client service and task-definition
* ECS Fargate server service and task-definition
* ALB
* Security Groups
