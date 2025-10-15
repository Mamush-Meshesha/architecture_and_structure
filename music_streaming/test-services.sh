#!/bin/bash
# Health Check Script for All Microservices

echo "🧪 Testing All Microservices Health Endpoints..."
echo "================================================"
echo ""

# Define services with their ports
declare -A services=(
  ["Gateway"]="8000"
  ["Auth"]="3001"
  ["Playlist"]="3002"
  ["Streaming"]="8080"
  ["Analytics"]="8081"
  ["AI"]="8001"
)

# Track results
passed=0
failed=0

# Test each service
for service in "${!services[@]}"; do
  port="${services[$service]}"
  
  echo -n "Testing $service service (port $port)... "
  
  # Make request with timeout
  response=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 http://localhost:$port/health 2>/dev/null)
  
  if [ "$response" = "200" ]; then
    echo "✅ OK"
    ((passed++))
  else
    echo "❌ FAILED (HTTP $response)"
    ((failed++))
  fi
done

echo ""
echo "================================================"
echo "Results: $passed passed, $failed failed"
echo ""

if [ $failed -eq 0 ]; then
  echo "✅ All services are healthy!"
  exit 0
else
  echo "❌ Some services failed health checks"
  echo "Run 'docker-compose logs' to investigate"
  exit 1
fi
