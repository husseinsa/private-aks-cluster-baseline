#!/bin/bash 

#Update and upgrade packages
sudo apt-get update -y
sudo apt-get upgrade -y 


# Install kubectl (latest)
echo "Installing kubectl..."

sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl &&
  chmod +x ./kubectl &&
  mv ./kubectl /usr/local/bin/kubectl


# Install helm v3 (latest)

echo "Installing Helm..."

sudo curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 &&
  chmod 700 get_helm.sh &&
  ./get_helm.sh

# Install Azure CLI (latest)
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
