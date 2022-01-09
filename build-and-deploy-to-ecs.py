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
# Verify the script should build, push, and deploy a new container to Fargate
# Somewhat redundant but feels better to have passed in to verify the intended action
parser.add_argument('--build', dest='build', action='store_true',
                    help='build new docker image', required=True)
parser.add_argument('--push', dest='push', action='store_true',
                    help='push new docker image to ECR')
parser.add_argument('--deploy', dest='deploy', action='store_true',
                    help='deploy new docker image to AWS Fargate')

args = parser.parse_args()
print(args)
# print(type(args.build_and_push))


def run_command(command):
    try:
        list_command = command.split(' ')
        print(list_command)
        call(list_command)
    except Exception as e:
        print(e)


def build_image(app):
    run_command(f'docker build -t client -f ./{app}/dockerfile .')
    

if __name__ == "__main__":
    # Always build a new image because the --build flag is required
    build_image(args.app)
