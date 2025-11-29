#!/bin/bash
# اسکریپت راه‌اندازی اولیه سرور - Server Initialization Script
# این اسکریپت وقتی سرور برای اولین بار روشن میشه اجرا میشه
# This script runs when server boots for the first time

# ====================================================================
# تنظیمات اولیه - Initial Settings
# ====================================================================

# خروج در صورت خطا - Exit on error
set -e

# لاگ تمام دستورات - Log all commands
set -x

# فایل لاگ - Log file
exec > >(tee /var/log/user-data.log)
exec 2>&1

echo "=========================================="
echo "Starting server initialization..."
echo "Date: $(date)"
echo "=========================================="

# ====================================================================
# آپدیت سیستم - System Update
# ====================================================================

echo "Step 1: Updating system packages..."
# آپدیت لیست پکیج‌ها - Update package list
apt-get update -y

# آپگرید پکیج‌ها - Upgrade packages
apt-get upgrade -y

# نصب ابزارهای پایه - Install basic tools
apt-get install -y \
    curl \
    wget \
    git \
    unzip \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release

echo "✓ System packages updated successfully"

# ====================================================================
# نصب Docker - Install Docker
# ====================================================================

echo "Step 2: Installing Docker..."

# حذف نسخه‌های قدیمی اگه وجود داشته باشه - Remove old versions if exists
apt-get remove -y docker docker-engine docker.io containerd runc || true

# اضافه کردن کلید GPG داکر - Add Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# اضافه کردن مخزن داکر - Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# آپدیت لیست پکیج‌ها - Update package list
apt-get update -y

# نصب Docker - Install Docker
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# راه‌اندازی Docker - Start Docker
systemctl start docker
systemctl enable docker

# بررسی نصب Docker - Check Docker installation
docker --version

echo "✓ Docker installed successfully"

# ====================================================================
# نصب Docker Compose - Install Docker Compose
# ====================================================================

echo "Step 3: Installing Docker Compose..."

# دانلود Docker Compose - Download Docker Compose
DOCKER_COMPOSE_VERSION="2.24.0"
curl -L "https://github.com/docker/compose/releases/download/v$${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose

# دادن مجوز اجرا - Make executable
chmod +x /usr/local/bin/docker-compose

# لینک symbolic - Create symbolic link
ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose

# بررسی نصب - Check installation
docker-compose --version

echo "✓ Docker Compose installed successfully"

# ====================================================================
# ساخت پوشه‌های پروژه - Create Project Directories
# ====================================================================

echo "Step 4: Creating project directories..."

# پوشه اصلی پروژه - Main project directory
mkdir -p /opt/${project_name}
cd /opt/${project_name}

echo "✓ Project directories created"

# ====================================================================
# دانلود کد اپلیکیشن - Download Application Code
# ====================================================================

echo "Step 5: Downloading application code..."

# کلون کردن repository از GitHub - Clone repository from GitHub
# توجه: repository باید public باشه یا از token استفاده کنید
# Note: repository must be public or use token
git clone https://github.com/kasragerami68/iac-multi-cloud-thesis.git temp_repo

# کپی کردن فقط پوشه app - Copy only app folder
cp -r temp_repo/app/* .

# پاک کردن پوشه موقت - Remove temporary folder
rm -rf temp_repo

echo "✓ Application code downloaded"

# ====================================================================
# ساخت فایل .env - Create .env File
# ====================================================================

echo "Step 6: Creating environment configuration..."

# ساخت فایل .env برای متغیرهای محیطی
# Create .env file for environment variables
cat > .env << EOF
# اطلاعات دیتابیس - Database Configuration
DB_HOST=${db_host}
DB_PORT=${db_port}
DB_NAME=${db_name}
DB_USER=${db_username}
DB_PASSWORD=${db_password}

# تنظیمات برنامه - Application Settings
APP_ENV=production
APP_DEBUG=false
APP_PORT=9090

# تنظیمات PHP - PHP Settings
PHP_MEMORY_LIMIT=256M
PHP_UPLOAD_MAX_FILESIZE=50M
PHP_POST_MAX_SIZE=50M
EOF

echo "✓ Environment configuration created"

# ====================================================================
# ویرایش docker-compose.yml - Edit docker-compose.yml
# ====================================================================

echo "Step 7: Configuring Docker Compose..."

# ساخت فایل docker-compose.yml جدید برای محیط Cloud
# Create new docker-compose.yml for Cloud environment
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  # سرویس وب - Web Service
  web:
    build: .
    container_name: ${project_name}-web
    ports:
      - "9090:80"
    environment:
      - DB_HOST=$${DB_HOST}
      - DB_PORT=$${DB_PORT}
      - DB_NAME=$${DB_NAME}
      - DB_USER=$${DB_USER}
      - DB_PASSWORD=$${DB_PASSWORD}
    volumes:
      - ./:/var/www/html
    restart: unless-stopped
    networks:
      - app-network

networks:
  app-network:
    driver: bridge
EOF

echo "✓ Docker Compose configured"

# ====================================================================
# راه‌اندازی اپلیکیشن - Start Application
# ====================================================================

echo "Step 8: Starting application..."

# ساخت و اجرای کانتینرها - Build and run containers
docker-compose up -d --build

# نمایش وضعیت کانتینرها - Show container status
docker-compose ps

echo "✓ Application started successfully"

# ====================================================================
# انتظار برای آماده شدن دیتابیس - Wait for Database
# ====================================================================

echo "Step 9: Waiting for database connection..."

# انتظار تا دیتابیس آماده بشه - Wait until database is ready
max_attempts=30
attempt=1

while [ $attempt -le $max_attempts ]; do
    echo "Attempt $attempt/$max_attempts: Checking database connection..."
    
    # تست اتصال به دیتابیس - Test database connection
    if docker-compose exec -T web php -r "new mysqli('${db_host}', '${db_username}', '${db_password}', '${db_name}');" 2>/dev/null; then
        echo "✓ Database connection successful!"
        break
    fi
    
    if [ $attempt -eq $max_attempts ]; then
        echo "✗ Failed to connect to database after $max_attempts attempts"
        exit 1
    fi
    
    echo "Database not ready yet, waiting 10 seconds..."
    sleep 10
    attempt=$((attempt + 1))
done

# ====================================================================
# Import دیتابیس (اگه فایل SQL داشته باشیم)
# Import Database (if SQL file exists)
# ====================================================================

echo "Step 10: Checking for database schema..."

# اگه فایل schema.sql وجود داشته باشه، import کن
# If schema.sql exists, import it
if [ -f "database/schema.sql" ]; then
    echo "Found database schema file, importing..."
    docker-compose exec -T web mysql -h ${db_host} -u ${db_username} -p${db_password} ${db_name} < database/schema.sql
    echo "✓ Database schema imported"
else
    echo "ℹ No database schema file found, skipping..."
fi

# ====================================================================
# تنظیمات فایروال - Firewall Settings
# ====================================================================

echo "Step 11: Configuring firewall..."

# نصب ufw - Install ufw
apt-get install -y ufw

# اجازه SSH - Allow SSH
ufw allow 22/tcp

# اجازه HTTP - Allow HTTP
ufw allow 80/tcp

# اجازه HTTPS - Allow HTTPS
ufw allow 443/tcp

# اجازه پورت اپلیکیشن - Allow application port
ufw allow 9090/tcp

# فعال کردن فایروال - Enable firewall
ufw --force enable

echo "✓ Firewall configured"

# ====================================================================
# نصب ابزارهای نظارتی - Install Monitoring Tools
# ====================================================================

echo "Step 12: Installing monitoring tools..."

# نصب htop برای نظارت منابع - Install htop for resource monitoring
apt-get install -y htop

# نصب netstat برای نظارت شبکه - Install net-tools for network monitoring
apt-get install -y net-tools

echo "✓ Monitoring tools installed"

# ====================================================================
# تنظیمات لاگ - Log Settings
# ====================================================================

echo "Step 13: Configuring logging..."

# ساخت پوشه لاگ - Create log directory
mkdir -p /var/log/${project_name}

# تنظیم logrotate برای مدیریت لاگ‌ها - Setup logrotate for log management
cat > /etc/logrotate.d/${project_name} << EOF
/var/log/${project_name}/*.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
}
EOF

echo "✓ Logging configured"

# ====================================================================
# ساخت اسکریپت‌های مدیریتی - Create Management Scripts
# ====================================================================

echo "Step 14: Creating management scripts..."

# اسکریپت restart - Restart script
cat > /usr/local/bin/${project_name}-restart << 'SCRIPT'
#!/bin/bash
cd /opt/${project_name}
docker-compose restart
echo "Application restarted"
SCRIPT

# اسکریپت stop - Stop script
cat > /usr/local/bin/${project_name}-stop << 'SCRIPT'
#!/bin/bash
cd /opt/${project_name}
docker-compose stop
echo "Application stopped"
SCRIPT

# اسکریپت start - Start script
cat > /usr/local/bin/${project_name}-start << 'SCRIPT'
#!/bin/bash
cd /opt/${project_name}
docker-compose start
echo "Application started"
SCRIPT

# اسکریپت logs - Logs script
cat > /usr/local/bin/${project_name}-logs << 'SCRIPT'
#!/bin/bash
cd /opt/${project_name}
docker-compose logs -f
SCRIPT

# دادن مجوز اجرا - Make executable
chmod +x /usr/local/bin/${project_name}-*

echo "✓ Management scripts created"

# ====================================================================
# اطلاعات نهایی - Final Information
# ====================================================================

echo "=========================================="
echo "Server initialization completed!"
echo "=========================================="
echo ""
echo "Application Information:"
echo "  - Application URL: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):9090"
echo "  - Database Host: ${db_host}"
echo "  - Database Name: ${db_name}"
echo ""
echo "Useful Commands:"
echo "  - Restart app: ${project_name}-restart"
echo "  - Stop app: ${project_name}-stop"
echo "  - Start app: ${project_name}-start"
echo "  - View logs: ${project_name}-logs"
echo ""
echo "Log files:"
echo "  - Initialization: /var/log/user-data.log"
echo "  - Application: /var/log/${project_name}/"
echo ""
echo "=========================================="

# نمایش وضعیت نهایی - Show final status
docker ps
netstat -tulpn | grep LISTEN

echo "Setup completed at: $(date)"