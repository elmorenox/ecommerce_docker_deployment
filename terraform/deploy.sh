#!/bin/bash
sudo apt-get update
sudo apt-get install -y docker.io docker-compose

# Docker login with passed credentials
echo "${docker_pass}" | docker login -u "${docker_user}" --password-stdin

mkdir -p /app
cd /app

cat > docker-compose.yml <<'EOL'
${docker_compose}
EOL

docker-compose pull
docker-compose up -d