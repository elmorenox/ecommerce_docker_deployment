#!/bin/bash

# Add logging
exec > >(tee /var/log/user-data-script.log) 2>&1
echo "Starting deployment script..."

echo "Updating packages..."
sudo apt-get update
echo "Package update complete"

echo "Installing Docker..."
sudo apt-get install -y docker.io docker-compose
echo "Docker installation complete"

echo "Attempting Docker login..."
echo "${docker_pass}" | docker login -u "${docker_user}" --password-stdin
echo "Docker login complete"

echo "Creating app directory..."
mkdir -p /app
cd /app
echo "Created and moved to /app"

echo "Creating docker-compose.yml..."
cat > docker-compose.yml <<EOF
${docker_compose}
EOF
echo "docker-compose.yml created"

echo "Pulling Docker images..."
docker-compose pull
echo "Images pulled"

echo "Starting containers..."
docker-compose up -d
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Containers started"
# FIN