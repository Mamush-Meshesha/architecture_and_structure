# Dexel AI Voice Companion - Architecture

## System Overview

Dexel is a cloud-native music streaming platform with AI-powered voice interaction capabilities, built on a microservices architecture.

## Architecture Principles

- **Microservices**: Independent, loosely coupled services
- **Event-Driven**: Kafka for async communication
- **Polyglot**: Right tool for the right job (Node.js, Go, Python, Rust)
- **Cloud-Native**: Kubernetes-ready, containerized deployments
- **Scalable**: Horizontal scaling for all services

## Core Services

### 1. Gateway Service (Node.js)
- **Purpose**: API Gateway and request routing
- **Tech**: Express.js, Node.js
- **Responsibilities**:
  - Request routing and load balancing
  - Authentication middleware
  - Rate limiting
  - API versioning

### 2. Auth Service (Node.js)
- **Purpose**: User authentication and authorization
- **Tech**: Node.js, Prisma, PostgreSQL
- **Responsibilities**:
  - User registration and login
  - JWT token generation and validation
  - Password hashing (bcrypt)
  - Session management

### 3. Playlist Service (Node.js)
- **Purpose**: Playlist management and social features
- **Tech**: Node.js, Prisma, PostgreSQL
- **Responsibilities**:
  - Create, update, delete playlists
  - Like/unlike songs
  - Share playlists
  - Follow/unfollow users

### 4. Streaming Service (Go)
- **Purpose**: High-performance audio streaming
- **Tech**: Go, MinIO, HLS/DASH
- **Responsibilities**:
  - HLS/DASH manifest generation
  - Audio segment delivery
  - Adaptive bitrate streaming
  - CDN integration

### 5. Analytics Service (Go)
- **Purpose**: Real-time analytics and event processing
- **Tech**: Go, Kafka, ClickHouse
- **Responsibilities**:
  - Consume Kafka events
  - Store analytics in ClickHouse
  - Generate reports
  - Track user behavior

### 6. AI Service (Python)
- **Purpose**: AI-powered features
- **Tech**: FastAPI, PyTorch, Transformers
- **Responsibilities**:
  - Automatic Speech Recognition (ASR)
  - Text-to-Speech (TTS)
  - Music recommendations
  - Voice commands processing

## Data Stores

### PostgreSQL
- User data
- Playlists
- Song metadata
- Relationships

### Redis
- Session cache
- Rate limiting
- Real-time data
- Pub/Sub messaging

### ClickHouse
- Analytics events
- User behavior tracking
- Aggregated metrics
- Time-series data

### MinIO (S3-compatible)
- Audio files
- Album artwork
- User avatars
- Static assets

### Kafka
- Event streaming
- Service-to-service communication
- Event sourcing
- Message queue

## Communication Patterns

### Synchronous
- REST APIs (Gateway ↔ Services)
- gRPC (Service ↔ Service)

### Asynchronous
- Kafka events
- Redis Pub/Sub

## Security

- JWT-based authentication
- API key validation
- Rate limiting
- DRM (future)
- Encrypted connections (TLS)

## Deployment

- **Containerization**: Docker
- **Orchestration**: Kubernetes
- **CI/CD**: GitHub Actions
- **Monitoring**: Prometheus + Grafana
- **Logging**: ELK Stack

## Scalability Strategy

- Horizontal pod autoscaling
- Database read replicas
- CDN for static content
- Kafka partitioning
- Redis clustering
