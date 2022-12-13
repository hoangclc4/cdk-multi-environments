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
            echo "Usage: $1"
            echo "OPTION includes:"
            echo "   -e | --env - Environment to deploy to, valid params: dev, stag, prod"
            echo "   -v | --version - prints out version information for this script"
            echo "   -p | --profile - [Optional], profile to use for aws cli commands"
            echo "   -s | --stack - [Optional], stack to deploy to cdk, default: sample-stack-{{env}}"
            echo "   -h | --help - displays this message"
            echo "Examples:"
            echo " ./diff.sh"
            echo " ./diff.sh --env dev"
            echo " ./diff.sh --env stag --profile myprofile"
            echo " ./diff.sh --stack sample-stack "
            exit
        ;;
        * )
            echo "Invalid option: $1"
            echo "OPTION includes:"
            echo "   -e | --env - Environment to deploy to, valid params: dev, stag, prod"
            echo "   -v | --version - prints out version information for this script"
            echo "   -p | --profile - [Optional], profile to use for aws cli commands"
            echo "   -s | --stack - [Optional], stack to deploy to cdk, default: sample-stack-{{env}}"
            echo "   -h | --help - displays this message"
            echo "Examples:"
            echo " ./diff.sh"
            echo " ./diff.sh --env dev"
            echo " ./diff.sh --env stag --profile myprofile --stack sample-stack"
            echo " ./diff.sh --stack sample-stack "
            exit
        ;;
    esac
    shift
done


#############################################################
# Main script
#############################################################

set -e
source ./env.sh --env $ENV --profile $PROFILE 
./build.sh

cd cdk
echo "Calculating diff"
echo "Command: npm run cdk-diff  --stack="${STACK_NAME_CHOOSEN}-${ENV}" --env=$ENV --profile=$PROFILE"
echo '--------------------------------------'
npm run cdk-diff --stack="${STACK_NAME_CHOOSEN}-${ENV}" --env=$ENV --profile=$PROFILE
cd -
