.PHONY: help up down restart logs ps health clean build

help:
	@echo "🚚 Dexel Mover & Packer - Commands"
	@echo "===================================="
	@echo ""
	@echo "Main Commands:"
	@echo "  make up          - Start all services"
	@echo "  make down        - Stop all services"
	@echo "  make restart     - Restart all services"
	@echo "  make logs        - View all logs"
	@echo "  make ps          - Show service status"
	@echo "  make health      - Check all health endpoints"
	@echo "  make clean       - Stop and remove everything"
	@echo "  make build       - Rebuild all services"
	@echo ""
	@echo "Infrastructure:"
	@echo "  make up-infra    - Start only infrastructure"
	@echo ""
	@echo "Individual Services:"
	@echo "  make up-gateway  - Start API gateway"
	@echo "  make up-auth     - Start auth service"
	@echo "  make up-booking  - Start booking service"
	@echo "  make up-listing  - Start listing service"
	@echo "  make up-pricing  - Start pricing service"
	@echo "  make up-payment  - Start payment service"
	@echo ""
	@echo "Logs:"
	@echo "  make logs-gateway   - View gateway logs"
	@echo "  make logs-auth      - View auth logs"
	@echo "  make logs-booking   - View booking logs"
	@echo ""

up:
	@echo "🚀 Starting all services..."
	docker-compose up -d
	@echo "✅ Services started! Run 'make health' to check status"

up-infra:
	@echo "🔧 Starting infrastructure services..."
	docker-compose up -d postgres-auth postgres-booking postgres-listing postgres-payment redis clickhouse redpanda minio
	@echo "✅ Infrastructure started!"

up-gateway:
	docker-compose up -d api-gateway

up-auth:
	docker-compose up -d auth-service

up-booking:
	docker-compose up -d booking-service

up-listing:
	docker-compose up -d listing-service

up-pricing:
	docker-compose up -d pricing-service

up-payment:
	docker-compose up -d payment-service

up-analytics:
	docker-compose up -d analytics-service

up-notification:
	docker-compose up -d notification-service

down:
	@echo "🛑 Stopping all services..."
	docker-compose down
	@echo "✅ Services stopped!"

restart:
	@echo "🔄 Restarting all services..."
	docker-compose restart
	@echo "✅ Services restarted!"

logs:
	docker-compose logs -f --tail=100

logs-gateway:
	docker-compose logs -f api-gateway

logs-auth:
	docker-compose logs -f auth-service

logs-booking:
	docker-compose logs -f booking-service

logs-listing:
	docker-compose logs -f listing-service

logs-pricing:
	docker-compose logs -f pricing-service

logs-payment:
	docker-compose logs -f payment-service

logs-analytics:
	docker-compose logs -f analytics-service

logs-notification:
	docker-compose logs -f notification-service

ps:
	@echo "📊 Service Status:"
	@docker-compose ps

health:
	@echo "🏥 Running health checks..."
	@echo ""
	@echo "API Gateway (3000):"
	@curl -s http://localhost:3000/health || echo "❌ Not responding"
	@echo ""
	@echo "Auth Service (3001):"
	@curl -s http://localhost:3001/health || echo "❌ Not responding"
	@echo ""
	@echo "Booking Service (3002):"
	@curl -s http://localhost:3002/health || echo "❌ Not responding"
	@echo ""
	@echo "Listing Service (3003):"
	@curl -s http://localhost:3003/health || echo "❌ Not responding"
	@echo ""
	@echo "Pricing Service (8000):"
	@curl -s http://localhost:8000/health || echo "❌ Not responding"
	@echo ""
	@echo "Payment Service (3004):"
	@curl -s http://localhost:3004/health || echo "❌ Not responding"
	@echo ""
	@echo "Notification Service (3005):"
	@curl -s http://localhost:3005/health || echo "❌ Not responding"
	@echo ""

clean:
	@echo "🧹 Cleaning up..."
	docker-compose down -v
	@echo "✅ Cleaned! All containers and volumes removed"

build:
	@echo "🔨 Rebuilding all services..."
	docker-compose build
	@echo "✅ Build complete!"

build-gateway:
	docker-compose build api-gateway

build-auth:
	docker-compose build auth-service

build-booking:
	docker-compose build booking-service

build-listing:
	docker-compose build listing-service

build-pricing:
	docker-compose build pricing-service

build-payment:
	docker-compose build payment-service

build-analytics:
	docker-compose build analytics-service

build-notification:
	docker-compose build notification-service

dev-gateway:
	@echo "🔧 Starting gateway in development mode..."
	cd services/api-gateway && npm install && npm run dev

dev-auth:
	@echo "🔧 Starting auth in development mode..."
	cd services/auth-service && npm install && npm run dev

dev-booking:
	@echo "🔧 Starting booking in development mode..."
	cd services/booking-service && npm install && npm run dev

dev-listing:
	@echo "🔧 Starting listing in development mode..."
	cd services/listing-service && npm install && npm run dev

dev-payment:
	@echo "🔧 Starting payment in development mode..."
	cd services/payment-service && npm install && npm run dev

dev-notification:
	@echo "🔧 Starting notification in development mode..."
	cd services/notification-service && npm install && npm run dev

dev-pricing:
	@echo "🔧 Starting pricing in development mode..."
	cd services/pricing-service && python -m venv venv && source venv/bin/activate && pip install -r requirements.txt && uvicorn app.main:app --reload --port 8000

db-migrate:
	@echo "📊 Running database migrations..."
	cd services/auth-service && npx prisma migrate dev
	cd services/booking-service && npx prisma migrate dev
	cd services/listing-service && npx prisma migrate dev
	cd services/payment-service && npx prisma migrate dev

stats:
	docker stats --no-stream

network:
	docker network inspect mover_and_packer_dexel-network
