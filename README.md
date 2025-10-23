# ServiceMap Infrastructure

Docker Compose-based development environment for the ServiceMap application.

## Overview

This repository contains the infrastructure setup for running ServiceMap in a development environment. It includes all necessary services orchestrated via Docker Compose.

## Services

### Core Services
- **Traefik** (Port 80, 443, 8080) - Reverse proxy and load balancer
- **PostgreSQL** (Port 5432) - Primary database (PostgreSQL 16)
- **Keycloak** (Port 8081) - Identity and access management
- **RabbitMQ** (Ports 5672, 15672) - Message broker with management UI
- **Redis** (Port 6379) - In-memory data store (Redis 7.4)
- **Redis Insight** (Port 5540) - Redis management and monitoring UI

### Monitoring & Observability
- **Prometheus** (Port 9090) - Metrics collection and storage
- **Grafana** (Port 3000) - Metrics visualization and dashboards

### Development Tools
- **MailHog** (Ports 1025, 8025) - Email testing tool

### Application Services
- **Gateway** (Port 8085) - ASP.NET Core API Gateway
- **UI** (Port 5173) - React frontend application

## Prerequisites

- Docker
- Docker Compose
- Git

## Quick Start

1. Clone the repository:
```bash
git clone <repository-url>
cd infra
```

2. Start all services:
```bash
docker-compose -f docker-compose.dev.yml --env-file .env.dev up -d
```

3. Stop all services:
```bash
docker-compose -f docker-compose.dev.yml --env-file .env.dev down
```

4. Stop and remove volumes:
```bash
docker-compose -f docker-compose.dev.yml --env-file .env.dev down -v
```

## Service Access

| Service | URL | Domain | Username | Password |
|---------|-----|--------|----------|----------|
| Traefik Dashboard | http://localhost:8080 | http://traefik.localhost | - | - |
| PostgreSQL | localhost:5432 | - | admin | admin |
| Keycloak Admin | http://localhost:8081 | http://keycloak.localhost | admin | admin |
| RabbitMQ Management | http://localhost:15672 | http://rabbitmq.localhost | admin | admin |
| Redis | localhost:6379 | - | - | - |
| Redis Insight | http://localhost:5540 | http://redis-insight.localhost | - | - |
| Prometheus | http://localhost:9090 | http://prometheus.localhost | - | - |
| Grafana | http://localhost:3000 | http://grafana.localhost | admin | admin |
| MailHog Web UI | http://localhost:8025 | http://mailhog.localhost | - | - |
| Gateway API | http://localhost:8085 | http://api.localhost | - | - |
| UI Application | http://localhost:5173 | http://localhost | - | - |

## Configuration

Environment variables are defined in `.env.dev`. Key configurations:

### Database
- `POSTGRES_USER=admin`
- `POSTGRES_PASSWORD=admin`
- `POSTGRES_DB=servicemap`

### Keycloak
- `KEYCLOAK_ADMIN=admin`
- `KEYCLOAK_ADMIN_PASSWORD=admin`

### RabbitMQ
- `RABBITMQ_DEFAULT_USER=admin`
- `RABBITMQ_DEFAULT_PASS=admin`

### Grafana
- `GRAFANA_ADMIN_USER=admin`
- `GRAFANA_ADMIN_PASSWORD=admin`

## Data Persistence

The following Docker volumes are used for data persistence:
- `postgres_data` - PostgreSQL database files
- `redis_data` - Redis data files
- `redis_insight_data` - Redis Insight configuration
- `rabbitmq_data` - RabbitMQ data and configuration
- `prometheus_data` - Prometheus metrics data
- `grafana_data` - Grafana dashboards and configuration

## Network

All services communicate through a dedicated Docker network: `servicemap-net`

## Initialization

### PostgreSQL
Custom initialization scripts are located in `postgres/init.sql` and run automatically on first startup.

### Keycloak
Realm configuration is automatically imported from `keycloak/realm-export.json` on startup.

### Redis Insight
A one-time configuration script (`redis-insight-init`) automatically adds the Redis instance to Redis Insight.

### Grafana
- Prometheus datasource is automatically provisioned
- Pre-configured Traefik Ingress Traffic dashboard is automatically loaded

## Monitoring

### Traefik Metrics
Traefik exposes Prometheus metrics on port 8082 (internal), which are scraped by Prometheus every 15 seconds. The metrics include:
- Request rates per entrypoint and router
- HTTP status code distribution
- Request duration percentiles (p50, p95, p99)
- Network traffic (bytes sent/received)

### Grafana Dashboards
Access Grafana at http://localhost:3000 (admin/admin) to view the pre-configured **Traefik Ingress Traffic** dashboard, which displays:
- Total request rates and counts
- Requests by router
- HTTP status code distribution
- Request duration percentiles
- Network traffic analysis

## Logging

All services use JSON file logging with:
- Maximum file size: 10MB
- Maximum files: 3

## Development

### Rebuilding Services
```bash
docker-compose -f docker-compose.dev.yml --env-file .env.dev up -d --build
```

### Viewing Logs
```bash
# All services
docker-compose -f docker-compose.dev.yml logs -f

# Specific service
docker-compose -f docker-compose.dev.yml logs -f <service-name>
```

### Accessing Service Shell
```bash
docker exec -it servicemap-<service-name> /bin/bash
```

## Troubleshooting

### Services not starting
Check service logs:
```bash
docker-compose -f docker-compose.dev.yml --env-file .env.dev logs
```

### Database connection issues
Ensure PostgreSQL is fully started before dependent services:
```bash
docker-compose -f docker-compose.dev.yml --env-file .env.dev ps
```

### Port conflicts
Ensure the required ports are not in use by other applications.

## License

See [LICENSE](LICENSE) file for details.