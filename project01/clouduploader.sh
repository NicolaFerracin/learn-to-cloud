#!/bin/bash

provider=""

# setup a globar variable with the selected could provider
setup() {
  if [ $1 = "aws" ];
  then
    provider="aws";
  elif [ $1 = "azure" ];
  then
    provider="azure";
  elif [ $1 = "gcp" ];
  then 
    provider="gcp";
  else 
    echo "No valid cloud provider specified";
    exit 1
  fi

  if [ ! -f "$2" ];
  then
    echo "No valid file provided"
    exit 1
  fi
}

installAws() {
  curr_version=($(aws --version))

  if [ "$curr_version" = "" ]
  then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
  fi

  echo "AWS version: $(aws --version)"
}

installAzure() {
  curr_version=($(az --version))

  if [ "$curr_version" = "" ]
  then
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
  fi

  echo "Azure version: $(az --version)"
}

installGcp() {
  echo "TBD"
}

loginAws() {
  hasProfile=$(aws configure get aws_access_key_id --profile default)
  if [[ "$hasProfile" == "" ]];
  then
    aws configure --profile default
  fi

}

loginAzure() {
  az login --use-device-code
}

loginGcp() {
  echo "TBD"
}

uploadAws() {
  read -p "Enter bucket name: " bucketName

  # if bucket already exists this won't do anything
  aws s3api create-bucket \
  --bucket "$bucketName" \
  --region us-east-1 \
  &> /dev/null

  # actual file upload
  aws s3 cp "$1" s3://"$bucketName"
}

if [ $# -eq 0 ];
then
  echo "No parameters provided"
  exit 1
elif [ $# -lt "2" ]
then
  echo "Not enough parameters provided"
  exit 1
fi

setup $1 $2

if [ "$provider" = "aws" ];
then
  installAws
  loginAws
  uploadAws $2
elif [ "$provider" = "azure" ];
then
  installAzure
  loginAzure
elif [ "$provider" = "gcp" ];
then
  installGcp
  loginGcp
fi
