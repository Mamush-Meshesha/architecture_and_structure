# Dexel Mover & Packer

## 🏗️ Architecture

**Microservices:** Gateway (TS) | Auth (TS) | Booking (TS) | Listing (TS) | Pricing (Python) | Payment (TS) | Analytics (Go) | Notification (TS)

**Infrastructure:** PostgreSQL | Redis | ClickHouse | Redpanda | MinIO

**Stack:** Node.js 20+ | Python 3.12+ | Go 1.22+ | Docker | Kubernetes

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for details.

## 📋 Prerequisites

- Docker 24.0+
- Docker Compose 2.20+
- Node.js 20+ (for local development)
- Python 3.12+ (for local development)
- Go 1.22+ (for local development)

## 🚀 Quick Start

```bash
git clone <repository-url> && cd mover_and_packer
make up && sleep 30 && make health
```

**Services:** Gateway:3000 | Auth:3001 | Booking:3002 | Listing:3003 | Pricing:8000 | Payment:3004 | Analytics:8001 | Notification:3005

**👉 See [GETTING_STARTED.md](GETTING_STARTED.md)** for setup, adding features, and scaling.

## 📦 Service Ports

| Service | Port | Protocol |
|---------|------|----------|
| API Gateway | 3000 | HTTP |
| Auth Service | 3001 | HTTP |
| Booking Service | 3002 | HTTP |
| Listing Service | 3003 | HTTP |
| Pricing Service | 8000 | HTTP |
| Payment Service | 3004 | HTTP |
| Notification Service | 3005 | HTTP |
| PostgreSQL (Auth) | 5432 | TCP |
| PostgreSQL (Booking) | 5433 | TCP |
| PostgreSQL (Listing) | 5434 | TCP |
| PostgreSQL (Payment) | 5435 | TCP |
| Redis | 6379 | TCP |
| ClickHouse HTTP | 8123 | HTTP |
| ClickHouse Native | 9000 | TCP |
| Redpanda Kafka | 19092 | TCP |
| Redpanda Schema Registry | 18081 | HTTP |
| MinIO API | 9000 | HTTP |
| MinIO Console | 9001 | HTTP |

## 🔧 Development

**Run Services Locally:**
```bash
make up-infra
cd services/auth-service && npm run dev
cd services/pricing-service && uvicorn app.main:app --reload
cd services/analytics-service && go run cmd/main.go
```

**Database Setup:**
```bash
# Node.js (Prisma)
cd services/auth-service && npx prisma migrate dev

# Python (Alembic)
cd services/pricing-service && alembic upgrade head

# Go (GORM/migrate)
cd services/analytics-service && go run migrations/migrate.go
```

**Build:**
```bash
make build
docker-compose build service-name
```

## 🧪 Testing

```bash
make health
cd services/auth-service && npm test
cd services/pricing-service && pytest
cd services/analytics-service && go test ./...
```

## 📊 Monitoring

**Consoles:**
- MinIO: http://localhost:9001
- Redpanda: http://localhost:19644

**Logging:**
```bash
make logs
make logs-auth
docker-compose logs -f service-name
```

## 🔐 Security

**Production Checklist:**
- Change default passwords
- Use strong JWT secrets (32+ chars)
- Enable TLS/SSL
- Configure RBAC in Kubernetes
- Set up secrets management
- Enable rate limiting
- Never commit secrets to git

## 🌍 Ethiopian Context

**Payment:** Telebirr | CBE Birr | Awash Birr | eChatPay
**SMS:** Ethio Telecom API
**Languages:** Amharic | Afaan Oromo | Tigrinya | English

## 📁 Structure

`services/` - Microservices | `shared/` - Common code | `kubernetes/` - K8s | `tests/` - Test suites

## 🚢 Deployment

**Docker Compose:**
```bash
docker-compose up -d
```

**Kubernetes:**
```bash
kubectl apply -f kubernetes/
kubectl get pods
```

## 📝 API Documentation

**Pricing Service:** http://localhost:8000/docs
**Gateway:** http://localhost:3000/api-docs

## 🎯 Adding Features & Scaling

See [GETTING_STARTED.md](GETTING_STARTED.md) for complete guide.

## 🤝 Contributing

1. Fork repository
2. Create feature branch: `git checkout -b feature/name`
3. Commit: `git commit -m 'feat: description'`
4. Push: `git push origin feature/name`
5. Open Pull Request

