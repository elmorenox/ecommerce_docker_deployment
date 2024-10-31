#!/bin/bash
echo "User data script started at $(date)" | sudo tee -a /var/log/user-data.log

# Update the package list and install Docker
sudo apt update
sudo apt install -y docker.io docker-compose

# Login to Docker Hub
echo "${dockerhub_password}" | sudo docker login -u "${dockerhub_username}" --password-stdin

# Create the app directory
mkdir -p /app
cd /app

# Write the docker-compose.yml content to a file
echo "${docker_compose_yml}" | sudo tee docker-compose.yml

# Start containers with RDS endpoint
DB_HOST=${rds_endpoint} sudo docker-compose up -d
