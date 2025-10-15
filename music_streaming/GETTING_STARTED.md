# 🚀 Getting Started

## Quick Setup
```bash
git clone <repo> && cd music_streaming
make up && sleep 30 && make health
```

**Services:** Gateway:8000 | Auth:3001 | Playlist:3002 | Streaming:8080 | Analytics:8081 | AI:8001

## Flow
```
Client → Gateway → Auth/Playlist/Streaming/AI → PostgreSQL/MinIO
                → Kafka → Analytics → ClickHouse
```

## Add Feature: Example Process

**1. Update Database Schema**
- Add new model/table to your database schema
- Define fields, relationships, and constraints

**2. Run Migration**
- Generate and apply database migration
- Update ORM client (Prisma/GORM/SQLAlchemy)

**3. Create Service Layer**
- Implement business logic
- Handle database operations (CRUD)

**4. Create Controller/Handler**
- Handle HTTP requests
- Call service layer
- Return responses

**5. Define Routes**
- Map HTTP endpoints to controllers
- Add authentication middleware

**6. Register Routes**
- Add routes to main application

**7. Test**
- Run service locally
- Test endpoints with curl/Postman

## Add Kafka Events

**1. Setup Kafka Producer**
- Initialize Kafka client with broker addresses
- Create producer instance

**2. Create Publish Function**
- Connect to Kafka
- Send messages to topics

**3. Publish Events in Service**
- After database operations, publish event
- Include relevant data (userId, action, timestamp)

## Scaling

**Horizontal Scaling (Add More Instances)**
- Docker: `docker-compose up -d --scale service-name=3`
- Kubernetes: `kubectl scale deployment service-name --replicas=5`

**Auto-scaling (Kubernetes)**
- Create HorizontalPodAutoscaler (HPA)
- Set min/max replicas
- Define CPU/memory thresholds (e.g., 70% CPU)

**Database Scaling**
- PostgreSQL: Add read replicas
- Redis: Enable cluster mode
- Kafka: Add more brokers
- ClickHouse: Add shards

**Caching Strategy**
- Check Redis cache first
- If miss, fetch from database
- Store in cache with TTL (e.g., 1 hour)
- Return data

## Commands
```bash
make up          # Start
make health      # Check
make logs        # Logs
make clean       # Reset
```

## Workflow
```bash
git checkout -b feature/name
npm run dev
git commit -m "feat: description"
git push origin feature/name
```

