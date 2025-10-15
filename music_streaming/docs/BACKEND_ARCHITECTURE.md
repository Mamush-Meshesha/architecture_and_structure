# Backend Microservices Architecture

**Polyglot Microservices + Event-Driven + CQRS** architecture chosen for scalability, language-specific optimization, and real-time features:

- Voice AI (ASR/TTS) - Python for ML libraries
- High-performance streaming - Go for concurrency
- Business logic - Node.js/TypeScript for rapid development
- Real-time analytics - ClickHouse for time-series
- Event streaming - Kafka for async communication

---

## 📂 Service Structure

```
services/
├── gateway-service/          # API Gateway (Node.js/TS)
│   ├── src/
│   │   ├── routes/          # Route definitions
│   │   ├── middleware/      # Auth, rate limiting
│   │   └── aggregators/     # Response aggregation
│   └── Dockerfile
│
├── auth-service/            # Authentication (Node.js/TS)
│   ├── src/
│   │   ├── controllers/     # HTTP handlers
│   │   ├── services/        # Business logic
│   │   ├── repositories/    # Data access (Prisma)
│   │   └── events/          # Kafka publishers
│   ├── prisma/schema.prisma
│   └── Dockerfile
│
├── playlist-service/        # Playlists (Node.js/TS)
│   ├── src/
│   │   ├── controllers/
│   │   ├── services/
│   │   ├── repositories/
│   │   └── events/
│   ├── prisma/schema.prisma
│   └── Dockerfile
│
├── streaming-service/       # Audio Streaming (Go)
│   ├── cmd/main.go
│   ├── internal/
│   │   ├── handlers/        # HTTP handlers
│   │   ├── services/        # HLS/DASH logic
│   │   ├── storage/         # MinIO client
│   │   └── cache/           # Redis cache
│   └── Dockerfile
│
├── analytics-service/       # Analytics (Go)
│   ├── cmd/main.go
│   ├── internal/
│   │   ├── handlers/
│   │   ├── consumers/       # Kafka consumers
│   │   ├── clickhouse/      # ClickHouse client
│   │   └── aggregators/     # Data aggregation
│   └── Dockerfile
│
└── ai-service/              # AI/ML (Python/FastAPI)
    ├── app/
    │   ├── api/             # FastAPI routes
    │   ├── services/        # ASR/TTS/Recommendations
    │   ├── models/          # ML model loading
    │   └── db/              # SQLAlchemy models
    ├── requirements.txt
    └── Dockerfile
```

---

## ⚙️ Core Design Choices

### 1. Language Selection

| Service    | Language   | Why                                      |
|------------|------------|------------------------------------------|
| Gateway    | TypeScript | Fast development, JSON handling          |
| Auth       | TypeScript | Prisma ORM, JWT libraries                |
| Playlist   | TypeScript | Complex business logic, rapid iteration  |
| Streaming  | Go         | High concurrency, low latency            |
| Analytics  | Go         | Efficient Kafka consumption              |
| AI         | Python     | ML libraries (Whisper, transformers)     |

---

### 2. Data Layers (Clean Architecture)

Each service follows:

```
controllers/ → services/ → repositories/ → database
     ↓            ↓            ↓
   HTTP      Business     Data Access
  Layer       Logic         Layer
```

**Benefits:**
- Testable business logic
- Swappable data sources
- Clear separation of concerns

---

### 3. Database Strategy

**PostgreSQL (Isolated per Service):**
- Auth Service → Users, sessions
- Playlist Service → Playlists, likes
- AI Service → Recommendations cache

**Redis:**
- Session cache (7 days TTL)
- Rate limiting counters
- Real-time presence

**ClickHouse:**
- Song play events
- User activity logs
- API metrics

**MinIO:**
- Audio files (HLS segments)
- Album artwork
- User uploads

---

### 4. Event-Driven Communication

**Kafka Topics:**
- `song.played` → Analytics, Recommendations
- `song.liked` → Social features, Analytics
- `playlist.created` → Notifications
- `user.registered` → Welcome email
- `payment.completed` → Subscription activation

**Pattern:**
```
Service A → Kafka Topic → Service B, C, D
(Publisher)              (Subscribers)
```

**Benefits:**
- Loose coupling
- Async processing
- Event replay for debugging

---

### 5. API Gateway Pattern

**Responsibilities:**
- Route requests to services
- JWT validation
- Rate limiting (100 req/min free, 1000 req/min premium)
- Response aggregation
- Request/response logging

**Example Flow:**
```
Client → Gateway → Auth Service (validate token)
                → Playlist Service (get data)
                → Response aggregation
```

---

### 6. Streaming Architecture

**Go Streaming Service:**
- Generates signed URLs for HLS manifests
- Handles adaptive bitrate (ABR) logic
- CDN integration (CloudFront/Cloudflare)
- DRM token validation

**Flow:**
```
Client → Streaming Service → MinIO (get manifest)
                           → Redis (cache manifest)
                           → Return signed URL
```

---

### 7. AI/ML Pipeline

**Python AI Service:**
- **ASR:** Whisper model for speech-to-text
- **TTS:** VITS/FastPitch for text-to-speech
- **Recommendations:** Collaborative filtering + embeddings
- **Model Serving:** FastAPI + GPU support

**Optimization:**
- Model caching in memory
- Batch inference for recommendations
- Async processing with Celery

---

### 8. Database Migrations

| Language   | Tool           | Command                              |
|------------|----------------|--------------------------------------|
| Node.js    | Prisma         | `npx prisma migrate dev`             |
| Python     | Alembic        | `alembic upgrade head`               |
| Go         | golang-migrate | `go run migrations/migrate.go`       |

---

### 9. Authentication Flow

```
1. User → Auth Service (login)
2. Auth Service → PostgreSQL (verify credentials)
3. Auth Service → Generate JWT (7 days)
4. Return JWT + Refresh Token (30 days)
5. Client → Gateway (with JWT in header)
6. Gateway → Validate JWT → Route to service
```

---

### 10. Why This Architecture Works

| Requirement                | Solution                                    |
|----------------------------|---------------------------------------------|
| Voice ASR/TTS              | Python AI service with ML libraries         |
| High-performance streaming | Go service with goroutines                  |
| Rapid feature development  | TypeScript services with Prisma ORM         |
| Real-time analytics        | Kafka → ClickHouse pipeline                 |
| Scalability                | Independent service scaling (K8s HPA)       |
| Multi-language support     | Each service uses optimal language          |
| Event replay & debugging   | Kafka topic retention (7-30 days)           |
| Offline-first mobile       | Signed URLs with long TTL                   |

---

## 🔧 Infrastructure Components

**Message Broker:**
- Kafka (3 brokers, replication factor 3)
- Topics: 10 partitions for high-throughput

**Caching:**
- Redis Cluster (3 masters, 3 replicas)
- Cache-aside pattern

**Storage:**
- MinIO (S3-compatible) for audio files
- PostgreSQL read replicas for scaling

**Monitoring:**
- Prometheus metrics on `/metrics`
- Grafana dashboards
- Jaeger for distributed tracing

---

## 🚀 Deployment Strategy

**Kubernetes:**
- Each service: 2-10 replicas (HPA based on CPU/memory)
- StatefulSets for databases
- Ingress for external traffic

**CI/CD:**
- GitHub Actions
- Docker image builds
- Automated testing
- Blue-green deployments

---

## 🧠 Scaling Patterns

**Horizontal Scaling:**
```bash
kubectl scale deployment gateway-service --replicas=10
```

**Database Scaling:**
- PostgreSQL: Read replicas
- Redis: Cluster mode
- ClickHouse: Sharding

**Caching Strategy:**
```
1. Check Redis cache
2. If miss → Query database
3. Store in cache (TTL: 1 hour)
4. Return data
```

---

This architecture provides **language-specific optimization, event-driven scalability, and clean separation** for a production-ready music streaming platform with AI voice capabilities.
