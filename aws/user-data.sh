#!/bin/bash
set -e

# Logging
exec > >(tee /var/log/user-data.log)
exec 2>&1

echo "=== User Data Script Started at $(date) ==="

# Update system
echo "Updating system..."
apt-get update -y
apt-get upgrade -y

# Install Docker
echo "Installing Docker..."
apt-get remove -y docker docker-engine docker.io containerd runc || true
apt-get install -y ca-certificates curl gnupg lsb-release

mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

systemctl start docker
systemctl enable docker

# Install Docker Compose
echo "Installing Docker Compose..."
curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose

# Install Git
echo "Installing Git..."
apt-get install -y git

# Create app directory
echo "Creating app directory..."
mkdir -p /opt/iac-web-app
cd /opt/iac-web-app

# Clone repository
echo "Cloning repository..."
git clone https://github.com/kasragerami68/iac-multi-cloud-thesis.git temp
cp -r temp/app/* .
rm -rf temp

# Create environment file
echo "Creating .env file..."
cat > .env << EOF
DB_HOST=${db_host}
DB_PORT=${db_port}
DB_NAME=${db_name}
DB_USER=${db_username}
DB_PASSWORD=${db_password}
EOF

# Wait for database
echo "Waiting for database..."
sleep 30

# Start application
echo "Starting application..."
docker-compose up -d

echo "=== User Data Script Completed at $(date) ==="