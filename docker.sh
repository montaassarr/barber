#!/bin/bash

# Reservi Docker Compose Helper

set -e

case "${1:-help}" in
  up)
    echo "🚀 Starting Reservi services..."
    docker-compose up -d
    echo "✅ Services started!"
    echo ""
    echo "📍 Access points:"
    echo "  Frontend:  http://localhost:3000"
    echo "  API:       http://localhost:4000"
    echo "  MongoDB:   mongodb://admin:password123@localhost:27017"
    echo ""
    echo "Run 'npm run seed' in backend container to initialize data"
    ;;
  down)
    echo "🛑 Stopping Reservi services..."
    docker-compose down
    echo "✅ Services stopped"
    ;;
  logs)
    docker-compose logs -f ${2:-}
    ;;
  build)
    echo "🔨 Building services..."
    docker-compose build
    echo "✅ Build complete"
    ;;
  seed)
    echo "🌱 Seeding database..."
    docker-compose exec backend npm run seed
    echo "✅ Database seeded"
    ;;
  ps)
    docker-compose ps
    ;;
  *)
    echo "Reservi Docker Compose Helper"
    echo ""
    echo "Usage: $0 {command} [options]"
    echo ""
    echo "Commands:"
    echo "  up       - Start all services"
    echo "  down     - Stop all services"
    echo "  logs     - View container logs (optional: service name)"
    echo "  build    - Build docker images"
    echo "  seed     - Seed the database"
    echo "  ps       - List running containers"
    ;;
esac
