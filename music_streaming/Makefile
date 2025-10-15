.PHONY: help up down restart logs ps test health clean build

# Default target
help:
	@echo "🎵 Dexel Music Streaming - Docker Commands"
	@echo "=========================================="
	@echo ""
	@echo "Available commands:"
	@echo "  make up          - Start all services"
	@echo "  make down        - Stop all services"
	@echo "  make restart     - Restart all services"
	@echo "  make logs        - View all logs"
	@echo "  make ps          - Show service status"
	@echo "  make test        - Run health checks"
	@echo "  make health      - Check all health endpoints"
	@echo "  make clean       - Stop and remove everything"
	@echo "  make build       - Rebuild all services"
	@echo ""
	@echo "Individual services:"
	@echo "  make up-infra    - Start only infrastructure"
	@echo "  make up-gateway  - Start gateway service"
	@echo "  make up-auth     - Start auth service"
	@echo "  make logs-gateway - View gateway logs"
	@echo ""

# Start all services
up:
	@echo "🚀 Starting all services..."
	docker-compose up -d
	@echo "✅ Services started! Run 'make health' to check status"

# Start only infrastructure
up-infra:
	@echo "🔧 Starting infrastructure services..."
	docker-compose up -d postgres redis clickhouse zookeeper kafka minio
	@echo "✅ Infrastructure started!"

# Start individual services
up-gateway:
	docker-compose up -d gateway-service

up-auth:
	docker-compose up -d auth-service

up-playlist:
	docker-compose up -d playlist-service

up-streaming:
	docker-compose up -d streaming-service

up-analytics:
	docker-compose up -d analytics-service

up-ai:
	docker-compose up -d ai-service

# Stop all services
down:
	@echo "🛑 Stopping all services..."
	docker-compose down
	@echo "✅ Services stopped!"

# Restart all services
restart:
	@echo "🔄 Restarting all services..."
	docker-compose restart
	@echo "✅ Services restarted!"

# View logs
logs:
	docker-compose logs -f --tail=100

logs-gateway:
	docker-compose logs -f gateway-service

logs-auth:
	docker-compose logs -f auth-service

logs-playlist:
	docker-compose logs -f playlist-service

logs-streaming:
	docker-compose logs -f streaming-service

logs-analytics:
	docker-compose logs -f analytics-service

logs-ai:
	docker-compose logs -f ai-service

# Show service status
ps:
	@echo "📊 Service Status:"
	@docker-compose ps

# Run health checks
health:
	@echo "🏥 Running health checks..."
	@./test-services.sh

# Quick test
test: health

# Clean everything
clean:
	@echo "🧹 Cleaning up..."
	docker-compose down -v
	@echo "✅ Cleaned! All containers and volumes removed"

# Rebuild services
build:
	@echo "🔨 Rebuilding all services..."
	docker-compose build
	@echo "✅ Build complete!"

# Rebuild specific service
build-gateway:
	docker-compose build gateway-service

build-auth:
	docker-compose build auth-service

build-playlist:
	docker-compose build playlist-service

build-streaming:
	docker-compose build streaming-service

build-analytics:
	docker-compose build analytics-service

build-ai:
	docker-compose build ai-service

# Development helpers
dev-gateway:
	@echo "🔧 Starting gateway in development mode..."
	cd services/gateway-service && npm install && npm run dev

dev-auth:
	@echo "🔧 Starting auth in development mode..."
	cd services/auth-service && npm install && npm run dev

dev-playlist:
	@echo "🔧 Starting playlist in development mode..."
	cd services/playlist-service && npm install && npm run dev

# Database helpers
db-migrate:
	@echo "📊 Running database migrations..."
	cd services/auth-service && npx prisma migrate dev
	cd services/playlist-service && npx prisma migrate dev

db-seed:
	@echo "🌱 Seeding database..."
	@echo "TODO: Add seed scripts"

# Show resource usage
stats:
	docker stats --no-stream

# Network inspection
network:
	docker network inspect music_streaming_default
