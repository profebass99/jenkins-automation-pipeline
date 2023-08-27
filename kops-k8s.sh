#!/bin/bash
sudo apt update -y
sudo apt install wget unzip -y

#install awscli
sudo apt remove awscli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Set AWS credentials as environment variables
export AWS_ACCESS_KEY_ID=********************
export AWS_SECRET_ACCESS_KEY=*
export AWS_DEFAULT_REGION=us-east-1


# install kubectl 
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

#install kops
wget https://github.com/kubernetes/kops/releases/download/v1.26.4/kops-linux-amd64
chmod +x kops-linux-amd64
sudo mv kops-linux-amd64 /usr/local/bin/kops

#install helm manager
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

kops create cluster --name=sundaydevops.com \
 --state=s3://kops-config-bucket-2023 --zones=us-east-1a,us-east-1b \
 --node-count=2 --node-size=t3.small --master-size=t3.medium \
 --dns-zone=sundaydevops.com \
 --node-volume-size=8 --master-volume-size=8

 kops update cluster --name sundaydevops.com --yes --admin --state=s3://kops-config-bucket-2023

kops validate cluster --name sundaydevops.com --wait 10m --state=s3://kops-config-bucket-2023

kops rolling-update cluster --state=s3://kops-config-bucket-2023
