#!/usr/bin/env bash

#############################################################
#Parsing options and arguments.
#############################################################

ENV='dev'
VERSION="1.0"
PROFILE="default"

while [ "$1" != "" ];
do
    case $1 in
        -e | --env )
            shift
            if [ $1 ]
            then
                ENV=$1
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
                
            else
                echo "Not a valid input in --profile" >&2
                exit
            fi
        ;;
        -h | --help )
            echo "Usage: $1 [OPTIONS]"
            echo "OPTION includes:"
            echo "   -e | --env - Environment to deploy to, valid params: dev, stag, prod"
            echo "   -v | --version - prints out version information for this script"
            echo "   -p | --profile - [Optional], profile to use for aws cli commands"
            echo "   -h | --help - displays this message"
            echo "   the command requires a filename argument"
            exit
        ;;
        * )
            echo "Invalid option: $1"
            echo "OPTION includes:"
            echo "   -e | --env - Environment to deploy to, valid params: dev, stag, prod"
            echo "   -v | --version - prints out version information for this script"
            echo "   -p | --profile - [Optional], profile to use for aws cli commands"
            echo "   -h | --help - displays this message"
            echo "   the command requires a filename argument"
            exit
        ;;
    esac
    shift
done


export MY_IP='118.69.55.211'

export AWS_SDK_LOAD_CONFIG=1 # allows the SDK to load from config. see https://github.com/aws/aws-sdk-js/pull/1391

## ====================================================================================================================
## 1. the CloudFormation stack name, e.g. "MyAppName"
## ====================================================================================================================

export STACK_NAME="nest-lambda"

## ====================================================================================================================
## 2. explicitly define the account you intend to deploy into
## ====================================================================================================================
echo "Using profile: $PROFILE"
export STACK_ACCOUNT=$(aws --profile $PROFILE sts get-caller-identity --query "Account" --output text)
export STACK_REGION=$(aws --profile $PROFILE configure get region)
