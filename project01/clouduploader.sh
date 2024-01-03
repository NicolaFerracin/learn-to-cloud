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
  fi
}

installAws() {
  curr_version=($(aws --version))

  if [ "$curr_version" = "" ]
  then
    curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
    sudo installer -pkg AWSCLIV2.pkg -target /
  fi

  echo "AWS version: $(aws --version)"
}

installAzure() {
  curr_version=($(az --version))

  if [ "$curr_version" = "" ]
  then
    brew update && brew install azure-cli
  fi

  echo "Azure version: $(az --version)"
}

installGcp() {
  echo "lol"
}

# download the provider CLI if not installed
install() {
  if [ "$provider" = "" ];
  then
    exit 1;
  fi

  if [ "$provider" = "aws" ];
  then
    installAws
  elif [ "$provider" = "azure" ];
  then
    installAzure
  elif [ "$provider" = "gcp" ];
  then
    installGcp
  fi
}

if (( $# == 0 )); then
  echo "No parameters provided"
  exit 1
fi

setup $1
install