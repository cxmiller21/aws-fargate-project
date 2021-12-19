# Infrastructure

Run AWS Fargate containers that are described in the frontend and backend folders

### Startup

```
$ terraform plan // preview resources that will be created
$ terraform apply // create resources
```

## Deployment

### AWS Resources Created

* ECS Fargate frontend service and task-definition
* ECS Fargate backend service and task-definition
* ALB
* Security Groups
