#!/bin/bash
sudo apt-get update
sudo apt-get install -y docker.io docker-compose

# Login to Docker Hub
echo "${dockerhub_password}" | sudo docker login -u "${dockerhub_username}" --password-stdin


# Set up app
mkdir -p /app
cd /app
# Copy docker-compose from repo
cp /dockerized-ecommerce-on-ec2/docker-compose.yml .
# Start containers with RDS endpoint
DB_HOST=${rds_endpoint} docker-compose up -d
