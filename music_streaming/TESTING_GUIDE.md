# Microservices Testing Guide

## 🧪 How to Test Each Microservice

This guide shows you how to test each microservice individually and together using Docker and Docker Compose.

---

## 🚀 Quick Start - Test All Services

### Option 1: Start Everything with Docker Compose
```bash
cd /home/mamush/Desktop/project/music_streaming

# Start all services and infrastructure
docker-compose up -d

# Check status
docker-compose ps

# View logs for all services
docker-compose logs -f

# View logs for specific service
docker-compose logs -f gateway-service
```

### Option 2: Start Only Infrastructure
```bash
# Start only databases and message queues (no application services)
docker-compose up -d postgres redis clickhouse zookeeper kafka minio
```

---

## 🔍 Test Individual Services

### 1️⃣ Gateway Service (Node.js/TypeScript)

#### Build Docker Image
```bash
cd services/gateway-service
docker build -t gateway-service:latest .
```

#### Run Container
```bash
docker run -d \
  --name gateway-service \
  -p 8000:8000 \
  -e NODE_ENV=development \
  -e PORT=8000 \
  gateway-service:latest
```

#### Test Health Endpoint
```bash
# Health check
curl http://localhost:8000/health

# Expected response:
# {"status":"healthy","service":"gateway"}

# Readiness check
curl http://localhost:8000/ready
```

#### View Logs
```bash
docker logs -f gateway-service
```

#### Stop and Remove
```bash
docker stop gateway-service
docker rm gateway-service
```

---

### 2️⃣ Auth Service (Node.js/TypeScript)

#### Build Docker Image
```bash
cd services/auth-service
docker build -t auth-service:latest .
```

#### Run with Docker Compose (includes Postgres)
```bash
# Start Postgres first
docker-compose up -d postgres

# Run auth service
docker run -d \
  --name auth-service \
  -p 3001:3001 \
  -e NODE_ENV=development \
  -e PORT=3001 \
  -e DATABASE_URL=postgresql://dexel:dexel_password@postgres:5432/dexel_db \
  --network music_streaming_default \
  auth-service:latest
```

#### Test Health Endpoint
```bash
curl http://localhost:3001/health

# Expected: {"status":"healthy","service":"auth"}
```

#### Test with Docker Compose
```bash
# Start auth service with dependencies
docker-compose up -d postgres redis auth-service

# Check logs
docker-compose logs -f auth-service
```

---

### 3️⃣ Playlist Service (Node.js/TypeScript)

#### Build and Run
```bash
cd services/playlist-service
docker build -t playlist-service:latest .

# Run with dependencies
docker-compose up -d postgres redis playlist-service

# Test health
curl http://localhost:3002/health
```

---

### 4️⃣ Streaming Service (Go)

#### Build Docker Image
```bash
cd services/streaming-service
docker build -t streaming-service:latest .
```

#### Run Container
```bash
# Start MinIO first
docker-compose up -d minio

# Run streaming service
docker run -d \
  --name streaming-service \
  -p 8080:8080 \
  -e PORT=8080 \
  -e MINIO_ENDPOINT=minio:9000 \
  -e MINIO_ACCESS_KEY=minioadmin \
  -e MINIO_SECRET_KEY=minioadmin \
  --network music_streaming_default \
  streaming-service:latest
```

#### Test Health Endpoint
```bash
curl http://localhost:8080/health

# Expected: {"status":"healthy","service":"streaming"}
```

#### Test with Docker Compose
```bash
docker-compose up -d minio streaming-service
docker-compose logs -f streaming-service
```

---

### 5️⃣ Analytics Service (Go)

#### Build and Run
```bash
cd services/analytics-service
docker build -t analytics-service:latest .

# Start dependencies
docker-compose up -d clickhouse kafka zookeeper

# Run analytics service
docker-compose up -d analytics-service

# Test health
curl http://localhost:8081/health
```

---

### 6️⃣ AI Service (Python)

#### Build Docker Image
```bash
cd services/ai-service
docker build -t ai-service:latest .
```

#### Run Container
```bash
docker run -d \
  --name ai-service \
  -p 8001:8001 \
  -e PORT=8001 \
  ai-service:latest
```

#### Test Health Endpoint
```bash
curl http://localhost:8001/health

# Expected: {"status":"healthy","service":"ai"}
```

#### Test with Docker Compose
```bash
docker-compose up -d ai-service
docker-compose logs -f ai-service
```

---

## 📊 Testing Scenarios

### Scenario 1: Test Gateway → Auth Flow
```bash
# Start required services
docker-compose up -d postgres redis auth-service gateway-service

# Wait for services to be ready (30 seconds)
sleep 30

# Test registration through gateway
curl -X POST http://localhost:8000/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123",
    "username": "testuser"
  }'
```

### Scenario 2: Test Full Stack
```bash
# Start all services
docker-compose up -d

# Wait for all services to be ready
sleep 60

# Check all health endpoints
echo "=== Gateway ===" && curl http://localhost:8000/health
echo "=== Auth ===" && curl http://localhost:3001/health
echo "=== Playlist ===" && curl http://localhost:3002/health
echo "=== Streaming ===" && curl http://localhost:8080/health
echo "=== Analytics ===" && curl http://localhost:8081/health
echo "=== AI ===" && curl http://localhost:8001/health
```

### Scenario 3: Test Infrastructure Only
```bash
# Start only infrastructure
docker-compose up -d postgres redis clickhouse kafka zookeeper minio

# Test Postgres
docker exec -it postgres psql -U dexel -d dexel_db -c "SELECT version();"

# Test Redis
docker exec -it redis redis-cli ping

# Test MinIO
curl http://localhost:9001  # MinIO Console
```

---

## 🔧 Useful Docker Compose Commands

### Start Services
```bash
# Start all services
docker-compose up -d

# Start specific service with dependencies
docker-compose up -d gateway-service

# Start without dependencies
docker-compose up -d --no-deps gateway-service

# Start and view logs
docker-compose up gateway-service
```

### Check Status
```bash
# List all containers
docker-compose ps

# Check resource usage
docker stats

# Inspect service
docker-compose logs gateway-service
docker-compose logs --tail=100 gateway-service
```

### Rebuild Services
```bash
# Rebuild specific service
docker-compose build gateway-service

# Rebuild all services
docker-compose build

# Rebuild and restart
docker-compose up -d --build gateway-service
```

### Stop Services
```bash
# Stop all services
docker-compose stop

# Stop specific service
docker-compose stop gateway-service

# Stop and remove containers
docker-compose down

# Stop and remove containers + volumes
docker-compose down -v
```

### Debug Services
```bash
# Execute command in running container
docker-compose exec gateway-service sh

# View environment variables
docker-compose exec gateway-service env

# Check network connectivity
docker-compose exec gateway-service ping postgres
```

---

## 🧪 Health Check Script

Create a test script to check all services:

```bash
#!/bin/bash
# save as: test-services.sh

echo "🧪 Testing All Microservices..."
echo ""

services=(
  "gateway:8000"
  "auth:3001"
  "playlist:3002"
  "streaming:8080"
  "analytics:8081"
  "ai:8001"
)

for service in "${services[@]}"; do
  name="${service%%:*}"
  port="${service##*:}"
  
  echo -n "Testing $name service on port $port... "
  
  response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$port/health)
  
  if [ "$response" = "200" ]; then
    echo "✅ OK"
  else
    echo "❌ FAILED (HTTP $response)"
  fi
done

echo ""
echo "✅ Health check complete!"
```

### Run the script:
```bash
chmod +x test-services.sh
./test-services.sh
```

---

## 📝 Testing Checklist

### Before Testing
- [ ] Docker is installed and running
- [ ] Docker Compose is installed
- [ ] Ports are available (8000, 3001, 3002, 8080, 8081, 8001)
- [ ] Sufficient disk space (at least 10GB)

### Individual Service Test
- [ ] Service builds successfully (`docker build`)
- [ ] Container starts without errors
- [ ] Health endpoint returns 200
- [ ] Logs show no critical errors
- [ ] Can connect to dependencies

### Integration Test
- [ ] All services start with `docker-compose up`
- [ ] All health checks pass
- [ ] Services can communicate
- [ ] Database connections work
- [ ] Kafka topics are created

---

## 🐛 Troubleshooting

### Service Won't Start
```bash
# Check logs
docker-compose logs service-name

# Check if port is already in use
lsof -i :8000

# Restart service
docker-compose restart service-name
```

### Database Connection Issues
```bash
# Check if Postgres is running
docker-compose ps postgres

# Test connection
docker-compose exec postgres psql -U dexel -d dexel_db

# Check network
docker network ls
docker network inspect music_streaming_default
```

### Build Failures
```bash
# Clean build
docker-compose build --no-cache service-name

# Remove old images
docker image prune -a

# Check Dockerfile syntax
docker build --progress=plain -t test .
```

### Port Conflicts
```bash
# Find what's using the port
sudo lsof -i :8000

# Kill the process
sudo kill -9 <PID>

# Or change port in docker-compose.yml
```

---

## 🎯 Quick Test Commands

```bash
# Test everything is working
docker-compose up -d && sleep 30 && \
  curl http://localhost:8000/health && \
  curl http://localhost:3001/health && \
  curl http://localhost:3002/health && \
  curl http://localhost:8080/health && \
  curl http://localhost:8081/health && \
  curl http://localhost:8001/health

# Clean slate restart
docker-compose down -v && docker-compose up -d

# View all logs
docker-compose logs -f --tail=100

# Check resource usage
docker stats --no-stream
```

---

## ✅ Success Indicators

Your services are working correctly if:

1. ✅ `docker-compose ps` shows all services as "Up"
2. ✅ All `/health` endpoints return `{"status":"healthy"}`
3. ✅ No error messages in `docker-compose logs`
4. ✅ Services can connect to their dependencies
5. ✅ Ports are accessible from host machine

---

## 📚 Additional Resources

- **Docker Compose Docs**: https://docs.docker.com/compose/
- **Health Checks**: Each service has `/health` and `/ready` endpoints
- **Logs Location**: Use `docker-compose logs` to view all logs
- **Network**: All services run on `music_streaming_default` network

