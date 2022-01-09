"""
ECS Deploy script

This script will build, push, and deploy a new docker container to an AWS ECS service

The script accepts the following arguments

1. Required: --app="client|server" - Defines if the client or server project folder should be used
2. Required: --build - confirms an image should be built
2. Optional: --push - will push previously build docker image to AWS ECR if added
3. Optional: --deploy - deploy the new image to an AWS Fargate service
"""

# import boto3 # Connect to AWS resources through an api
import argparse # Pass args to script
from subprocess import call # Run terminal commands

parser = argparse.ArgumentParser(description='ECS Deploy Script.')

parser.add_argument('--app', metavar='client or server', type=str, choices=['client', 'server'], required=True,
                    help='the application to build and deploy', dest='app')
parser.add_argument('--aws-acct-id', metavar='aws account id', type=str, required=True,
                    help='the aws account id', dest='aws_acct_id')
# Verify the script should build, push, and deploy a new container to Fargate
# Somewhat redundant but feels better to have passed in to verify the intended action
parser.add_argument('--build', dest='build', action='store_true',
                    help='build new docker image', required=True)
parser.add_argument('--push', dest='push', action='store_true',
                    help='push new docker image to ECR')
parser.add_argument('--deploy', dest='deploy', action='store_true',
                    help='deploy new docker image to AWS Fargate')
parser.add_argument('--region', dest='region', type=str, default='us-east-1',
                    help='AWS region (us-east-1')
parser.add_argument('--ecr-repo', dest='base_ecr_repo', type=str, default='aws-fargate-project',
                    help='AWS ECR repo (this script will append "client" or "server" to the end of this repo value)')

args = parser.parse_args()
print(args)
# print(type(args.build_and_push))


def run_command(command):
    try:
        # Subrpocess requires a list of strings to be passed example "call(['cd ..', 'ls']"
        # This will split the required commands and make it easier to run them
        list_command = command.split(' ')
        print(list_command)
        call(list_command)
    except Exception as e:
        print(e)

def login_to_ecr(region, ecr_root):
    login_command = f'aws ecr get-login-password --region {region} | docker login --username AWS --password-stdin {ecr_root}'
    print(login_command)
    # call(login_command)

def build_image(ecr_repo, docker_file_path):
    build_cmd = f'docker build -t {ecr_repo} -f {docker_file_path} .'
    print(build_cmd)
    # run_command(build_cmd)
    

def push_image(ecr_repo):
    push_cmd = f'docker push {ecr_repo}'
    print(push_cmd)
    # call(push_cmd)
    
def deploy_to_fargate():
    """[summary]
    1. Get latest ECS service's current task-definition as output file
    2. Get latest ECR image arn to use in a new task definition
    3. Modify task-definition output file with new ecr image arn
    4. Create a new task-definition with the modified output file
    5. Modify the ECS service to run the new task-definition
    6. Verify the new task definition is running successfully
    """
    

if __name__ == "__main__":
    
    region = args.region
    app = args.app
    ecr_root=f'{args.aws_acct_id}.dkr.ecr.us-east-1.amazonaws.com'
    ecr_repo = f'{ecr_root}/{args.base_ecr_repo}-{app}'
    docker_file_path = f'./{app}/Dockerfile' # this could be an arg
    
    login_to_ecr(region, ecr_root)
    build_image(ecr_repo, docker_file_path)
    push_image(ecr_repo)
    
    deploy_to_fargate()
