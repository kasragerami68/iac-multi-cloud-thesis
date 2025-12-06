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

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Start Docker
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

# Create .env file
echo "Creating .env file..."
cat > .env << 'EOF'
DB_HOST=${db_host}
DB_PORT=3306
DB_NAME=community_db
DB_USER=kasra
DB_PASSWORD=test1234
APP_ENV=production
APP_DEBUG=false
APP_PORT=9090
PHP_MEMORY_LIMIT=256M
PHP_UPLOAD_MAX_FILESIZE=50M
PHP_POST_MAX_SIZE=50M
EOF

# Wait for database
echo "Waiting for database..."
sleep 30

# Start application
echo "Starting application..."
docker-compose up -d

echo "=== User Data Script Completed at $(date) ==="