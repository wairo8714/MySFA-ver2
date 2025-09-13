#!/bin/bash

# Install Docker
yum update -y
yum install -y docker
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Start application
cat > /home/ec2-user/docker-compose.yml << EOF
version: '3.8'
services:
  app:
    image: ${dockerhub_username}/mysfa_ver2:latest
    ports:
      - "8000:8000"
    environment:
      - MYSQL_HOST=${mysql_host}
      - MYSQL_PORT=3306
      - MYSQL_DATABASE=mysfa_db
      - MYSQL_USER=admin
      - MYSQL_PASSWORD=${mysql_password}
      - SECRET_KEY=${secret_key}
      - DEBUG=False
      - ALLOWED_HOSTS=*
    restart: unless-stopped
EOF

# Launch application
cd /home/ec2-user
docker-compose up -d
