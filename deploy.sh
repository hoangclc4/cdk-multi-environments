#!/bin/bash

#############################################################
#Parsing options and arguments.
#############################################################

ENV='dev'
VERSION="1.0"
PROFILE="default"
STACK_NAME_CHOOSEN="nest-lambda"

while [ "$1" != "" ];
do
    case $1 in
        -e | --env )
            shift
            if [ $1 ]
            then
                ENV=$1
                echo "ENV: $ENV"
            else
                echo "Not a valid input in --env" >&2
                exit
            fi
        ;;
        -v | --version )
            echo "Version: $VERSION"
        ;;
        -p | --profile )
            shift
            if [ $1 ]
            then
                PROFILE=$1
                echo "PROFILE: $PROFILE"
                
            else
                echo "Not a valid input in --profile" >&2
                exit
            fi
        ;;
        -s | --stack )
            shift
            if [ $1 ]
            then
                STACK_NAME_CHOOSEN=$1
                echo "STACK_NAME_CHOOSEN: $STACK_NAME_CHOOSEN"
                
            else
                echo "Not a valid input in --stack" >&2
                exit
            fi
        ;;
        -h | --help )
            echo "Usage: $1 [OPTIONS]"
            echo "OPTION includes:"
            echo "   -e | --env - Environment to deploy to, valid params: dev, stag, prod"
            echo "   -v | --version - prints out version information for this script"
            echo "   -p | --profile - [Optional], profile to use for aws cli commands"
            echo "   -s | --stack - [Optional], stack to deploy to cdk, default: nest-lambda-{{env}}"
            echo "   -h | --help - displays this message"
            echo "Examples:"
            echo " ./deploy.sh"
            echo " ./deploy.sh --env dev"
            echo " ./deploy.sh --env stag --profile myprofile"
            echo " ./deploy.sh --stack sample-stack"
            exit
        ;;
        * )
            echo "Invalid option: $1"
            echo "OPTION includes:"
            echo "   -e | --env - Environment to deploy to, valid params: dev, stag, prod"
            echo "   -v | --version - prints out version information for this script"
            echo "   -p | --profile - [Optional], profile to use for aws cli commands"
            echo "   -s | --stack - [Optional], stack to deploy to cdk, default: nest-lambda-{{env}}"
            echo "   -h | --help - displays this message"
            echo "Examples:"
            echo " ./deploy.sh"
            echo " ./deploy.sh --env dev"
            echo " ./deploy.sh --env stag --profile myprofile"
            echo " ./deploy.sh --stack sample-stack"
            exit
        ;;
    esac
    shift
done


#############################################################
# Main script
#############################################################

echo "Building backend "
set -e
source ./env.sh --env $ENV --profile $PROFILE 
./build.sh

echo "Deploying backend stack..."
# deploy the cdk stack (ignore the error in case it's due to 'No updates are to be performed')
if [ "$STACK_NAME_CHOOSEN" == "$STACK_NAME" ]; then
    echo "Command: npm run cdk-deploy --silent --prefix cdk --env=$ENV --profile=$PROFILE || true"
    echo '--------------------------------------'
    npm run cdk-deploy --silent --prefix cdk --env=$ENV --profile=$PROFILE || true
else
    echo "Invalid stack name: $STACK_NAME_CHOOSEN"
    exit
fi

STACK_STATUS=$(aws --profile $PROFILE cloudformation describe-stacks --stack-name "${STACK_NAME}-$ENV" --region "${STACK_REGION}" --query "Stacks[].StackStatus[]" --output text)

if [[ "${STACK_STATUS}" != "CREATE_COMPLETE" && "${STACK_STATUS}" != "UPDATE_COMPLETE" ]]; then
  echo "Stack is in an unexpected status: ${STACK_STATUS}"
  exit 1
fi
