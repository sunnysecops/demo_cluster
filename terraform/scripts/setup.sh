#!/bin/bash

## Script to setup devCluster ##

## Declaring Variables ##
HOME="/home/ubuntu"
INFO_LOG="/var/log/demo_cluster/info.log"
DEBUG_LOG="/var/log/demo_cluster/debug.log"

## Fixing Locale ##
export LC_ALL="en_US.UTF-8"

## Install basic packages and creating log directories ##
apt-get update -y
apt-get install htop
apt-get install openssl -y
apt-get install git -y
apt-get install python3-pip -y

## Create Directories ##
mkdir -p  /var/log/demo_cliuster
touch $INFO_LOG $DEBUG_LOG
chown -R ubuntu:ubuntu /var/log/demo_cluster
chmod -R 777 /var/log/demo_cluster

function setupAWSCLI() {
    ## Funtion to install and setup awscli ##
	echo "[$(date '+%Y-%m-%d:%H:%M:%S')] INFO [Installing and configuring AWS CLI]" >> $INFO_LOG;
    sudo apt-get install awscli -y > /dev/null
	sudo apt-get install python-pip -y > /dev/null
	sudo pip install --upgrade awscli > /dev/null
}

function setupDocker() {
	## Installing Docker ##
	echo "[$(date '+%Y-%m-%d:%H:%M:%S')] INFO [Installing Docker]" >> $INFO_LOG;
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	sudo apt-get update  > /dev/null
	sudo apt-cache policy docker-ce  > /dev/null
    sudo apt-get install -y docker-ce  > /dev/null
    sudo apt install docker.io -y  > /dev/null
    sudo systemctl start docker  > /dev/null
	sudo systemctl enable docker  > /dev/null
	sudo chmod 777 /var/run/docker.sock
	sudo usermod -aG docker ubuntu

	## Installing Docker Compose ##
	echo "[$(date '+%Y-%m-%d:%H:%M:%S')] INFO [Installing docker compose]" >> $INFO_LOG;
	sudo curl -L "https://github.com/docker/compose/releases/download/1.28.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
	docker-compose --version
}

function setupKubectl() {
    ## Function to setup kubectl ##
	echo "[$(date '+%Y-%m-%d:%H:%M:%S')] INFO [Setting up Kubectl]" >> $INFO_LOG;
	curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl > /dev/null
	chmod +x ./kubectl
	sudo mv ./kubectl /usr/local/bin/kubectl
}

function setupMinikube(){
	## Function to setup and start minikube ##
	echo "[$(date '+%Y-%m-%d:%H:%M:%S')] INFO [Setting up minikube]" >> $INFO_LOG;
	curl -Lo minikube_binary https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
	&& chmod +x minikube_binary
	sudo mv minikube_binary /usr/local/bin/minikube > /dev/null
	echo "[$(date '+%Y-%m-%d:%H:%M:%S')] INFO [Starting minikube cluster]" >> $INFO_LOG;
	minikube start --driver=none}

function setupArgocd(){
	##Function to setup argocd
	echo "[$(date '+%Y-%m-%d:%H:%M:%S')] INFO [Setting up Argocd]" >> $INFO_LOG;
	kubectl create namespace argocd
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.0.0/manifests/install.yaml
}


setupAWSCLI >> $DEBUG_LOG 2>&1
setupDocker >> $DEBUG_LOG 2>&1
setupKubectl >> $DEBUG_LOG 2>&1
setupMinikube >> $DEBUG_LOG 2>&1
setupArgocd >> $DEBUG_LOG 2>&1
