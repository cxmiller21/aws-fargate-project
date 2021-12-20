# AWS Fargate Project

AWS Fargate infrastructure running a simple client site with a nodejs server.

## Getting Started

### Prerequisites

The things you need before installing the software.

* AWS account
* Terraform v1
* Nodejs v16
* Vue CLI
* Set the AWS_ACCOUNT_ID variable in the client and server `push_to_ecr.sh` scripts

### Installation

```
// Client
$ cd client
$ npm install
$ npm run serve

// Server
$ cd server
$ npm install
$ node server.js
```

## Deployment

> Create the AWS infrastructure that will run the client and server containers.

Open 3 terminals and cd into the client, server, and infrastructure folders.

```
// 1. (Infrastructure folder) Create the ECR Image Registries in the infrastructure folder)
$ terraform apply -target="aws_ecr_repository.main"

// 2. (Server folder) Build and push the node image to ECR
$ npm run push:image

// 3. (Infrastructure folder) Create the main ECS infrastructure and node fargate server
$ terraform apply

// 4. (AWS Console) Get the Public IP address of the node task
// Optionally run the following to test the server can be reached
$ curl node_public_ip_address:3000/getData

// 5. (Client folder) Update the /client/src/components/NodeCall.vue "fargateNodeIP" variable (Since the Vue client will be compiled, this needs to be set this manually instead of using a container variable)

// 6. (Client folder) Build and push the vue image to ECR
$ npm run push:image

// 7. (Infrastructure folder) After the image is pushed to ECR, set the client.tf "node_task_ip_address_updated" variable to true
$ terraform apply

// 8. Open a new tab with the 'vue-client' task's Public IP address and you should see the vue app with a message from the node server.
```

### Branches

* Main:

## Next Steps

Some useful features and ways to expand this demo project

* GitHub Actions for CI/CD Deployments when changes are pushed to the client or server folders
* AWS Monitoring dashboard for Fargate containers
* AWS Monitoring alarms and notifications for Fargate containers
* Create an ALB to remove the need to use public IP addresses
* Write automation scripts with Python or Go to assist with the Deployment process
* Add auto-scaling to Fargate Services
