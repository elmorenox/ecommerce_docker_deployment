#!/bin/bash

# Create .ssh directory if it doesn't exist
sudo mkdir -p /home/ubuntu/.ssh

# Write SSH private key from Terraform variable to file
sudo cat > /home/ubuntu/.ssh/id_rsa << 'EOL'
${ssh_private_key}
EOL

# Set proper permissions
sudo chmod 700 /home/ubuntu/.ssh
sudo chmod 600 /home/ubuntu/.ssh/id_rsa
sudo chown -R ubuntu:ubuntu /home/ubuntu/.ssh

echo "${codon_pubkey}" | sudo tee /home/ubuntu/.ssh/authorized_keys > /dev/null
sudo chmod 600 /home/ubuntu/.ssh/authorized_keys
sudo chown ubuntu:ubuntu /home/ubuntu/.ssh/authorized_keys
echo "Replaced authorized_keys with codon public key"

echo "SSH private key and configuration set up successfully"

