#!/bin/bash

# Exit script on any error
set -e

# STEP-1: INSTALLING GIT, JAVA, AND MAVEN
echo "Installing Git, Java (Amazon Corretto), and Maven..."
sudo yum install -y git maven
sudo yum install -y java-11-amazon-corretto

# STEP-2: CONFIGURING JENKINS REPOSITORY
echo "Configuring Jenkins repository..."
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# STEP-3: INSTALLING JENKINS
echo "Installing Jenkins..."
sudo yum install -y jenkins

# Configure default Java version if needed
echo "Configuring default Java version..."
sudo update-alternatives --config java

# STEP-4: STARTING AND ENABLING JENKINS
echo "Starting Jenkins service..."
sudo systemctl start jenkins.service
sudo systemctl enable jenkins.service

# Checking Jenkins status
echo "Checking Jenkins status..."
sudo systemctl status jenkins.service

# Displaying initial admin password for Jenkins setup
echo "Jenkins installation complete. Retrieving initial admin password..."
if [ -f /var/lib/jenkins/secrets/initialAdminPassword ]; then
    echo "Initial Admin Password:"
    sudo cat /var/lib/jenkins/secrets/initialAdminPassword
else
    echo "Error: Initial Admin Password file not found!"
fi

# Providing Jenkins access information
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
echo "Access Jenkins at: http://${PUBLIC_IP}:8080"

