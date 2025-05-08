#!/bin/bash
apt update
apt install -y fontconfig openjdk-17-jre

# Install Docker with updated key handling
apt install -y apt-transport-https ca-certificates curl software-properties-common

sudo apt install -y python3-dev libjpeg-dev zlib1g-dev libfreetype6-dev liblcms2-dev python3-pip

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update
apt install -y docker-ce docker-ce-cli containerd.io
usermod -aG docker ubuntu

# Install Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
apt update
apt install -y terraform

mkdir -p /home/ubuntu/.ssh
chmod 700 /home/ubuntu/.ssh

cat > /home/ubuntu/.ssh/id_rsa << 'EOL'
${ssh_private_key}
EOL

# Set proper permissions
chmod 700 /home/ubuntu/.ssh
chmod 600 /home/ubuntu/.ssh/id_rsa
chown -R ubuntu:ubuntu /home/ubuntu/.ssh