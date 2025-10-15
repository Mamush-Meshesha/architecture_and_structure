# Mover & Packer Backend Architecture

**Polyglot Microservices + Event-Driven + Ethiopian Payment Integration** architecture optimized for:

- Moving & packing logistics
- Housing marketplace (rent/buy/sell)
- Dynamic pricing with traffic-aware routing
- Ethiopian payment gateways (Telebirr, CBE Birr, Awash Birr, eChatPay)
- Real-time booking tracking
- Multi-language support (Amharic, Afaan Oromo, Tigrinya, English)

---

## 📂 Service Structure

```
services/
├── api-gateway/              # API Gateway (Node.js/TS)
│   ├── src/
│   │   ├── routes/          # Route definitions
│   │   ├── middleware/      # Auth, rate limiting, CORS
│   │   └── aggregators/     # Response aggregation
│   └── Dockerfile
│
├── auth-service/            # Authentication & KYC (Node.js/TS)
│   ├── src/
│   │   ├── controllers/     # HTTP handlers
│   │   ├── services/        # Business logic, KYC verification
│   │   ├── repositories/    # Data access (Prisma)
│   │   └── events/          # Redpanda publishers
│   ├── prisma/schema.prisma
│   └── Dockerfile
│
├── booking-service/         # Move Bookings (Node.js/TS)
│   ├── src/
│   │   ├── controllers/
│   │   ├── services/        # Inventory calculation, vehicle matching
│   │   ├── repositories/
│   │   ├── tracking/        # Real-time location tracking
│   │   └── events/
│   ├── prisma/schema.prisma
│   └── Dockerfile
│
├── listing-service/         # Housing Marketplace (Node.js/TS)
│   ├── src/
│   │   ├── controllers/
│   │   ├── services/        # Property listings (rent/buy/sell)
│   │   ├── repositories/
│   │   ├── search/          # Elasticsearch integration
│   │   └── events/
│   ├── prisma/schema.prisma
│   └── Dockerfile
│
├── pricing-service/         # Dynamic Pricing (Python/FastAPI)
│   ├── app/
│   │   ├── api/             # FastAPI routes
│   │   ├── services/        # Pricing algorithms
│   │   ├── routing/         # Traffic-aware routing (Google Maps API)
│   │   ├── scoring/         # Marketplace scoring
│   │   └── db/              # SQLAlchemy models
│   ├── requirements.txt
│   └── Dockerfile
│
├── payment-service/         # Ethiopian Payments (Node.js/TS)
│   ├── src/
│   │   ├── controllers/
│   │   ├── gateways/        # Telebirr, CBE, Awash, eChatPay
│   │   ├── webhooks/        # Payment confirmations
│   │   ├── reconciliation/  # Payment reconciliation
│   │   └── events/
│   ├── prisma/schema.prisma
│   └── Dockerfile
│
├── analytics-service/       # Analytics (Go)
│   ├── cmd/main.go
│   ├── internal/
│   │   ├── handlers/
│   │   ├── consumers/       # Redpanda consumers
│   │   ├── clickhouse/      # ClickHouse client
│   │   └── aggregators/     # KPI calculations
│   └── Dockerfile
│
└── notification-service/    # Notifications (Node.js/TS)
    ├── src/
    │   ├── controllers/
    │   ├── channels/        # SMS, Push, WhatsApp, Email
    │   ├── templates/       # Multi-language templates
    │   └── events/          # Redpanda consumers
    └── Dockerfile
```

---

## ⚙️ Core Design Choices

### 1. Language Selection

| Service      | Language   | Why                                           |
|--------------|------------|-----------------------------------------------|
| Gateway      | TypeScript | Fast development, JSON handling               |
| Auth         | TypeScript | Prisma ORM, JWT libraries, KYC integration    |
| Booking      | TypeScript | Complex business logic, real-time tracking    |
| Listing      | TypeScript | Search integration, rapid iteration           |
| Pricing      | Python     | ML libraries, routing algorithms              |
| Payment      | TypeScript | Payment gateway SDKs, webhook handling        |
| Analytics    | Go         | High-performance Redpanda consumption         |
| Notification | TypeScript | Multi-channel integration                     |

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
- Swappable payment gateways
- Clear separation of concerns

---

### 3. Database Strategy

**PostgreSQL (Isolated per Service):**
- Auth Service → Users, KYC data (port 5432)
- Booking Service → Bookings, inventory (port 5433)
- Listing Service → Properties, listings (port 5434)
- Payment Service → Transactions, reconciliation (port 5435)

**Redis:**
- Session cache (7 days TTL)
- Rate limiting counters
- Real-time tracking cache
- Job queues

**ClickHouse:**
- Booking events
- User activity logs
- Payment analytics
- Marketplace metrics

**MinIO:**
- Property images
- Moving inventory photos
- User documents (KYC)
- Receipts & invoices

---

### 4. Event-Driven Communication

**Redpanda Topics:**
- `booking.created` → Notifications, Analytics
- `booking.confirmed` → Payment, Tracking
- `payment.completed` → Booking, Notifications
- `listing.created` → Search indexing, Notifications
- `user.registered` → Welcome SMS, KYC verification

**Pattern:**
```
Service A → Redpanda Topic → Service B, C, D
(Publisher)                  (Subscribers)
```

**Benefits:**
- Loose coupling
- Async processing
- Event replay for debugging

---

### 5. Ethiopian Payment Integration

**Payment Gateways:**
- **Telebirr**: Mobile money (Ethio Telecom)
- **CBE Birr**: Commercial Bank of Ethiopia
- **Awash Birr**: Bank of Awash
- **eChatPay**: eChat payment platform

**Payment Flow:**
```
1. User → Payment Service (initiate payment)
2. Payment Service → Gateway SDK (Telebirr/CBE/etc)
3. Gateway → User (payment prompt)
4. User → Gateway (confirm payment)
5. Gateway → Payment Service (webhook callback)
6. Payment Service → Verify signature
7. Payment Service → Update booking status
8. Payment Service → Publish payment.completed event
```

**Webhook Security:**
- Signature verification
- IP whitelist
- Idempotency keys
- Retry mechanism

---

### 6. Booking & Tracking Flow

**Booking Creation:**
```
1. User → Booking Service (create booking)
2. Booking Service → Calculate inventory volume
3. Booking Service → Match vehicle type
4. Booking Service → Pricing Service (get quote)
5. Pricing Service → Google Maps API (distance + traffic)
6. Pricing Service → Calculate dynamic price
7. Booking Service → Return quote to user
8. User → Confirm booking
9. Booking Service → Publish booking.created event
```

**Real-time Tracking:**
- Driver app sends GPS coordinates
- Booking Service stores in Redis (TTL: 1 hour)
- WebSocket/SSE pushes updates to user
- Analytics Service logs to ClickHouse

---

### 7. Housing Marketplace

**Listing Service:**
- CRUD for properties (rent/buy/sell)
- Image upload to MinIO
- Elasticsearch for search
- Scoring algorithm (location, price, amenities)

**Search Flow:**
```
1. User → Listing Service (search query)
2. Listing Service → Elasticsearch (full-text search)
3. Elasticsearch → Return matching listings
4. Listing Service → Pricing Service (score listings)
5. Pricing Service → Return scored results
6. Listing Service → Return to user
```

---

### 8. Dynamic Pricing

**Python Pricing Service:**
- **Distance-based**: Google Maps API for route calculation
- **Traffic-aware**: Real-time traffic data
- **Demand-based**: Surge pricing during peak hours
- **Marketplace scoring**: Location, amenities, market trends

**Pricing Formula:**
```python
base_price = distance * rate_per_km
traffic_multiplier = 1.0 + (traffic_delay / 60) * 0.1
demand_multiplier = 1.0 + (current_bookings / capacity) * 0.2
final_price = base_price * traffic_multiplier * demand_multiplier
```

---

### 9. Multi-language Support

**Supported Languages:**
- Amharic (አማርኛ)
- Afaan Oromo
- Tigrinya (ትግርኛ)
- English

**Implementation:**
- i18n keys in notification templates
- Language preference in user profile
- SMS/Email templates per language
- API responses in user's language

---

### 10. Database Migrations

| Language   | Tool           | Command                              |
|------------|----------------|--------------------------------------|
| Node.js    | Prisma         | `npx prisma migrate dev`             |
| Python     | Alembic        | `alembic upgrade head`               |
| Go         | golang-migrate | `go run migrations/migrate.go`       |

---

### 11. Why This Architecture Works

| Requirement                     | Solution                                        |
|---------------------------------|-------------------------------------------------|
| Ethiopian payments              | Payment Service with gateway abstraction        |
| Dynamic pricing                 | Python service with ML & routing algorithms     |
| Real-time tracking              | Redis cache + WebSocket/SSE                     |
| Housing marketplace             | Listing Service + Elasticsearch                 |
| Multi-language                  | i18n templates in Notification Service          |
| Scalability                     | Independent service scaling (K8s HPA)           |
| Event replay & debugging        | Redpanda topic retention (7-30 days)            |
| Payment reconciliation          | Dedicated reconciliation module                 |
| KYC verification                | Auth Service with document upload               |

---

## 🔧 Infrastructure Components

**Message Broker:**
- Redpanda (Kafka-compatible, 3 brokers)
- Topics: 5-10 partitions for high-throughput

**Caching:**
- Redis (single instance for dev, cluster for prod)
- Cache-aside pattern

**Storage:**
- MinIO (S3-compatible) for images/documents
- PostgreSQL (isolated per service)

**Monitoring:**
- Prometheus metrics on `/metrics`
- Grafana dashboards
- Jaeger for distributed tracing

---

## 🚀 Deployment Strategy

**Kubernetes:**
- Each service: 2-5 replicas (HPA based on CPU/memory)
- StatefulSets for databases
- Ingress for external traffic

**CI/CD:**
- GitHub Actions
- Docker image builds
- Automated testing
- Rolling updates

---

## 🧠 Scaling Patterns

**Horizontal Scaling:**
```bash
kubectl scale deployment booking-service --replicas=5
```

**Database Scaling:**
- PostgreSQL: Read replicas per service
- Redis: Cluster mode
- ClickHouse: Sharding

**Caching Strategy:**
```
1. Check Redis cache
2. If miss → Query database
3. Store in cache (TTL: 30 minutes)
4. Return data
```

---

## 🇪🇹 Ethiopian Context

**Payment Gateways:**
- Telebirr API integration
- CBE Birr webhook handling
- Awash Birr SDK
- eChatPay REST API

**SMS Provider:**
- Ethio Telecom SMS API for OTP
- Multi-language SMS templates

**Localization:**
- Ethiopian calendar support
- Amharic/Oromo/Tigrinya UI
- Local phone number formats (+251)

---

This architecture provides **Ethiopian-first payment integration, dynamic pricing, and real-time tracking** for a production-ready moving & packing platform with housing marketplace.
