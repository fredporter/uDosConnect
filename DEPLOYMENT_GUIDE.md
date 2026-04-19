# uDos Deployment Guide
# Cycle 1, Round 3: Production Deployment

## 📋 Overview

This guide provides step-by-step instructions for deploying uDos in production environments. The guide covers single-server deployments, multi-server clusters, and Docker containerization.

## 🎯 Prerequisites

### System Requirements
- **Node.js**: 18.x or 20.x LTS
- **npm**: 9.x or higher
- **SQLite**: 3.38+ (included with Node.js)
- **MySQL**: 5.7+ (required for WP integration)
- **Git**: 2.30+
- **Operating System**: Linux (Ubuntu 22.04 recommended), macOS 13+, or Windows 10+

### Network Requirements
- **Port 8080**: Main application port
- **Port 8085**: Webhook listener (optional)
- **Port 3010**: MCP agent connections
- **Outbound**: HTTPS (443) for npm packages and API calls

### Capacity Planning
| Component | Min Requirements | Recommended | Notes |
|-----------|------------------|-------------|-------|
| CPU | 2 cores | 4+ cores | More cores for heavy AI usage |
| RAM | 4GB | 8+ GB | Includes Node.js and database |
| Disk | 10GB | 50+ GB | Depends on feed size |
| Network | 10 Mbps | 100+ Mbps | Faster for sync operations |

## 📦 Installation

### 1. Clone Repository

```bash
# HTTPS (recommended)
git clone https://github.com/fredporter/uDos.git
git checkout main

# Or SSH
git clone git@github.com:fredporter/uDos.git
```

### 2. Install Dependencies

```bash
cd uDos
npm install

# Build all packages
npm run build
```

### 3. Configure Environment

Create `.env` file in project root:

```bash
cp .env.example .env

# Edit .env with your settings
nano .env
```

**Required variables:**
```env
# Core configuration
UDOS_VAULT=~/vault
UDOS_SAFETY=normal
UDOS_ROUND=0.5.0

# Database (for WP integration)
WP_DB_HOST=localhost
WP_DB_USER=wordpress
WP_DB_PASSWORD=your_secure_password
WP_DB_NAME=wordpress

# Network
PORT=8080
WEBHOOK_PORT=8085

# Security
JWT_SECRET=generate_with_openssl_rand_32
API_KEY=your_api_key_for_integration
```

### 4. Database Setup

#### SQLite (included)
No setup required - automatically created in `UDOS_VAULT`

#### MySQL (for WP integration)
```bash
# Install MySQL
sudo apt update
sudo apt install mysql-server

# Secure MySQL
sudo mysql_secure_installation

# Create database and user
mysql -u root -p -e "CREATE DATABASE wordpress;"
mysql -u root -p -e "CREATE USER 'wordpress'@'localhost' IDENTIFIED BY 'your_secure_password';"
mysql -u root -p -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost';"
mysql -u root -p -e "FLUSH PRIVILEGES;"
```

## 🚀 Deployment Options

### Option 1: Direct Node.js Deployment (Recommended)

```bash
# Start in production mode
NODE_ENV=production npm start

# Or use PM2 for process management
npm install -g pm2
pm2 start ecosystem.config.js
pm2 save
pm2 startup  # Auto-start on boot
```

Create `ecosystem.config.js`:
```javascript
module.exports = {
  apps: [{
    name: 'udos',
    script: 'core/dist/cli.js',
    args: 'start',
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '1G',
    env: {
      NODE_ENV: 'production',
      UDOS_VAULT: process.env.HOME + '/vault',
      UDOS_SAFETY: 'normal'
    }
  }]
};
```

### Option 2: Docker Deployment

Create `Dockerfile`:
```dockerfile
FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install --production

COPY . .

RUN npm run build

EXPOSE 8080 8085

CMD ["node", "core/dist/cli.js", "start"]
```

Build and run:
```bash
docker build -t udos:latest .
docker run -d -p 8080:8080 -p 8085:8085 --name udos udos:latest
```

### Option 3: Kubernetes Deployment

Create `deployment.yaml`:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: udos
spec:
  replicas: 2
  selector:
    matchLabels:
      app: udos
  template:
    metadata:
      labels:
        app: udos
    spec:
      containers:
      - name: udos
        image: udos:latest
        ports:
        - containerPort: 8080
        - containerPort: 8085
        env:
        - name: NODE_ENV
          value: "production"
        - name: UDOS_VAULT
          value: "/data/vault"
        - name: UDOS_SAFETY
          value: "normal"
        volumeMounts:
        - name: vault-storage
          mountPath: /data/vault
      volumes:
      - name: vault-storage
        persistentVolumeClaim:
          claimName: udos-vault-pvc
```

Create `service.yaml`:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: udos
spec:
  selector:
    app: udos
  ports:
  - name: http
    port: 80
    targetPort: 8080
  - name: webhook
    port: 8085
    targetPort: 8085
```

Apply configurations:
```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

## 🔧 Configuration

### Environment Variables

Set in `.env` or deployment configuration:

```env
# Core
UDOS_VAULT=/path/to/vault
UDOS_SAFETY=normal  # strict, normal, or relaxed
UDOS_ROUND=0.5.0
UDOS_SPINE=main

# Network
PORT=8080
WEBHOOK_PORT=8085
HOST=0.0.0.0

# Database
WP_DB_HOST=localhost
WP_DB_USER=wordpress
WP_DB_PASSWORD=your_password
WP_DB_NAME=wordpress
WP_DB_PORT=3306

# Security
JWT_SECRET=your_32_char_secret
API_KEY=your_api_key
SESSION_SECRET=another_32_char_secret

# Performance
MAX_MEMORY=1024  # MB
WORKER_THREADS=4
BATCH_SIZE=50

# Logging
LOG_LEVEL=info  # error, warn, info, debug
LOG_FILE=/var/log/udos.log
```

### Configuration Files

Edit `.udos/config.yaml` for development settings:
```yaml
safety:
  level: normal  # or "strict" for production
  require_review_for: [code_gen, refactor, major]

round:
  current: "0.5.0"
  duration_days: 10
```

## 🛡️ Security

### Best Practices

1. **Secrets Management**
   - Use environment variables, never hardcode
   - Rotate secrets regularly
   - Use vault systems for production

2. **Network Security**
   - Enable firewall (ufw/iptables)
   - Restrict ports (8080, 8085)
   - Use HTTPS with Let's Encrypt

3. **Authentication**
   - Enforce strong passwords
   - Implement rate limiting
   - Use JWT with short expiry

4. **Updates**
   - Regular dependency updates
   - Security patch management
   - Automated vulnerability scanning

### SSL/TLS Setup

```bash
# Install certbot
sudo apt install certbot

# Obtain certificate
sudo certbot certonly --standalone -d yourdomain.com

# Configure to auto-renew
sudo certbot renew --dry-run
```

Update `.env`:
```env
SSL_CERT=/etc/letsencrypt/live/yourdomain.com/fullchain.pem
SSL_KEY=/etc/letsencrypt/live/yourdomain.com/privkey.pem
HTTPS=true
HTTP_REDIRECT=true
```

## 🔄 Updates & Maintenance

### Update Process

```bash
# Pull latest changes
git pull origin main

# Update dependencies
npm update

# Rebuild
npm run build

# Restart
pm2 restart udos  # If using PM2
# or
systemctl restart udos  # If using systemd
```

### Backup Strategy

```bash
# Daily backup script
#!/bin/bash
# Backup vault
tar -czvf /backups/vault-$(date +%Y-%m-%d).tar.gz ~/vault

# Backup database
mysqldump -u wordpress -pyour_password wordpress > /backups/wp-$(date +%Y-%m-%d).sql

# Keep last 7 backups
find /backups -type f -name "*.tar.gz" -mtime +7 -delete
find /backups -type f -name "*.sql" -mtime +7 -delete
```

### Monitoring

```bash
# Check logs
pm2 logs

# Monitor performance
pm2 monit

# Check health
udo health

# System metrics
htop
vmstat 1
iostat -x 1
```

## 🚨 Troubleshooting

### Common Issues

**Port already in use**
```bash
# Find process
sudo lsof -i :8080

# Kill process
kill -9 <PID>
```

**Database connection failed**
```bash
# Test MySQL connection
mysql -u wordpress -p -h localhost

# Check MySQL status
sudo systemctl status mysql
```

**Memory issues**
```bash
# Increase Node.js memory
node --max-old-space-size=4096 core/dist/cli.js

# Or update in ecosystem.config.js
max_memory_restart: '2G'
```

**Build failures**
```bash
# Clean and rebuild
rm -rf node_modules package-lock.json
npm install
npm run build
```

## 📊 Performance Tuning

### Optimization Tips

1. **Database Indexes**
   ```sql
   -- Add indexes for frequent queries
   CREATE INDEX idx_user_email ON wp_users(user_email);
   CREATE INDEX idx_user_login ON wp_users(user_login);
   ```

2. **Caching**
   ```bash
   # Enable Redis caching (future)
   npm install redis
   ```

3. **Worker Threads**
   ```javascript
   // In config.yaml
   worker_threads: 4  # Match CPU cores
   ```

4. **Batch Processing**
   ```javascript
   // In config.yaml
   batch_size: 100  # For user sync
   ```

## 📖 Post-Deployment Checks

### Verify Installation

```bash
# Check version
udo version

# Test network
udo network status

# Verify WP connection
udo wp test-connection

# Run safety checks
udo safety check
```

### Monitor Services

```bash
# Check logs
journalctl -u udos -f  # systemd
pm2 logs  # PM2

# Check ports
netstat -tuln | grep 8080
ss -tuln | grep 8080

# Test API
curl -X GET http://localhost:8080/api/health
```

### Benchmark Performance

```bash
# Simple benchmark
time curl http://localhost:8080/api/health

# Load testing (install artillery)
npm install -g artillery
artillery quick --count 100 -n 20 http://localhost:8080/api/health
```

## 🎯 Scaling

### Vertical Scaling
- Increase CPU/RAM
- Optimize database queries
- Enable caching

### Horizontal Scaling (Future)
- Multiple instances behind load balancer
- Shared Redis cache
- Database read replicas

### Cluster Setup (Future)
```yaml
# ecosystem.config.js for clustering
module.exports = {
  apps: [{
    name: 'udos',
    script: 'core/dist/cli.js',
    instances: 4,  # Number of clusters
    exec_mode: 'cluster'
  }]
};
```

## 📚 Resources

- [uDos Documentation](https://github.com/fredporter/uDos/wiki)
- [Node.js Best Practices](https://github.com/goldbergyoni/nodebestpractices)
- [Production Checklist](https://github.com/microsoft/TypeScript-Node-Starter)
- [Security Guide](https://github.com/goldbergyoni/nodebestpractices#1-project-structure-practices)

## 🤝 Support

- **GitHub Issues**: https://github.com/fredporter/uDos/issues
- **Discussions**: https://github.com/fredporter/uDos/discussions
- **Community**: Join our Discord (future)

---

**Deployment Guide v1.0** | Last Updated: 2026-04-20 | uDos 0.5.0
