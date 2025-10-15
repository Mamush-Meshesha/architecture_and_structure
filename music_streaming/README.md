# Dexel AI Voice Companion - Music Streaming Platform


## 🏗️ Architecture

**Microservices:** Gateway (TS) | Auth (TS) | Playlist (TS) | Streaming (Go) | Analytics (Go) | AI (Python)

**Infrastructure:** PostgreSQL | Redis | ClickHouse | Kafka | MinIO | Zookeeper

**Stack:** Node.js 18+ | Go 1.21+ | Python 3.11+ | Docker | Kubernetes

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for details.

## 📋 Prerequisites

- Docker 24.0+
- Docker Compose 2.20+
- Node.js 18+ (for local development)
- Go 1.21+ (for local development)
- Python 3.11+ (for local development)
- Make (optional, for convenience commands)

## 🚀 Quick Start

```bash
git clone <repository-url> && cd music_streaming
make up && sleep 30 && make health
```

**Services:** Gateway:8000 | Auth:3001 | Playlist:3002 | Streaming:8080 | Analytics:8081 | AI:8001

**👉 See [GETTING_STARTED.md](GETTING_STARTED.md)** for setup, adding features, and scaling.

## 📦 Service Ports

| Service | Port | Protocol | Description |
|---------|------|----------|-------------|
| Gateway Service | 8000 | HTTP | Main API entry point |
| Auth Service | 3001 | HTTP | Authentication |
| Playlist Service | 3002 | HTTP | Playlist management |
| Streaming Service | 8080 | HTTP | Audio streaming |
| Analytics Service | 8081 | HTTP | Analytics & metrics |
| AI Service | 8001 | HTTP | AI features |
| PostgreSQL | 5432 | TCP | Primary database |
| Redis | 6379 | TCP | Cache & sessions |
| ClickHouse HTTP | 8123 | HTTP | Analytics queries |
| ClickHouse Native | 9000 | TCP | Native protocol |
| Kafka | 9092 | TCP | Message broker |
| Kafka (External) | 29092 | TCP | External access |
| Zookeeper | 2181 | TCP | Kafka coordination |
| MinIO API | 9000 | HTTP | Object storage |
| MinIO Console | 9001 | HTTP | Admin interface |

## 📁 Structure

`services/` - Microservices | `shared/` - Common code | `infra/` - Configs | `kubernetes/` - K8s | `docs/` - Documentation

## 🔧 Development

**Run Services Locally:**
```bash
make up-infra                  
cd services/auth-service && npm run dev
cd services/streaming-service && go run cmd/main.go
cd services/ai-service && uvicorn app.main:app --reload
```

**Database Setup:**
```bash
# Node.js (Prisma)
cd services/auth-service && npx prisma migrate dev

# Go (GORM/migrate)
cd services/streaming-service && go run migrations/migrate.go

# Python (Alembic)
cd services/ai-service && alembic upgrade head
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
cd services/streaming-service && go test ./...
cd services/ai-service && pytest
```

See [TESTING_GUIDE.md](TESTING_GUIDE.md) for details.

## 📖 Documentation

**⭐ [GETTING_STARTED.md](GETTING_STARTED.md)** - Setup, add features, scale (100 lines)

**Detailed Docs:**
- [docs/BACKEND_ARCHITECTURE.md](docs/BACKEND_ARCHITECTURE.md) - Backend architecture & design
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) - System overview

## 🚢 Deployment

**Docker Compose:**
```bash
docker-compose up -d
docker-compose ps
docker-compose logs -f
```

**Kubernetes:**
```bash
kubectl apply -f kubernetes/
kubectl get pods -n dexel
kubectl scale deployment gateway-service --replicas=3 -n dexel
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

## 📊 Monitoring

**Health Endpoints:** `/health` | `/ready` | `/metrics`

**Logging:**
```bash
make logs                        # All logs
make logs-gateway                # Specific service
docker-compose logs -f service-name
```

**Metrics:** Prometheus | Grafana | Jaeger | ELK (future)

## 📝 API Documentation

Once services are running, access API documentation:
- **AI Service**: http://localhost:8001/docs (FastAPI auto-generated)

## 🎯 Adding Features & Scaling

See [GETTING_STARTED.md](GETTING_STARTED.md) for complete guide.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes and write tests
4. Commit: `git commit -m 'feat: add amazing feature'`
5. Push: `git push origin feature/amazing-feature`
6. Open a Pull Request

**Code Style**: TypeScript (Airbnb), Go (Effective Go), Python (PEP 8)

## 🐛 Troubleshooting

**Services won't start:**
```bash
make logs              # Check all logs
make restart           # Restart services
```

**Port conflicts:**
```bash
lsof -i :8000         # Find process
kill -9 <PID>         # Kill process
```

**Database issues:**
```bash
docker-compose restart postgres
docker-compose exec postgres psql -U dexel -d dexel_db
```

**Clean restart:**
```bash
make clean && make up
```

For more, see [GETTING_STARTED.md](GETTING_STARTED.md)

## 📄 License

MIT License

---

