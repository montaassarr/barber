# Barber Salon Management System - API Test Scripts

This directory contains comprehensive test scripts for testing all CRUD operations and endpoints of the Barber Salon Management System API.

## Overview

The test scripts verify that all API endpoints are working correctly with proper Row Level Security (RLS) policies enabled. They test:

- ✓ Salons CRUD operations (Create, Read, Update, Delete)
- ✓ Services CRUD operations
- ✓ Appointments CRUD operations
- ✓ Proper RLS policy enforcement
- ✓ Authentication and authorization
- ✓ Data validation

## Available Test Scripts

### 1. `test-local.sh` (Recommended)
**Bash script for testing against local Docker Supabase**

Tests the local Docker Supabase instance (port 54321). Best for development and CI/CD pipelines.

```bash
bash test-local.sh
```

**Features:**
- Tests against `http://localhost:54321`
- Simple, readable bash implementation
- Color-coded output
- Tests full CRUD cycle

### 2. `test-comprehensive.py`
**Python script for detailed testing**

More advanced testing with better error handling and detailed assertions.

```bash
python3 test-comprehensive.py
```

**Requirements:**
```bash
pip install requests
```

### 3. `test-all-endpoints.sh`
**Comprehensive bash test suite**

Extended testing with more detailed coverage of all endpoints and error cases.

```bash
bash test-all-endpoints.sh
```

## Setup

### Prerequisites

1. **Docker & Docker Compose Running**
```bash
# Start local Supabase and frontend
cd /home/montassar/Desktop/reservi
docker compose up -d
```

2. **Wait for Services to Start** (approximately 30 seconds)
```bash
# Check container health
docker compose ps

# Verify Supabase REST API is responding
curl -s http://localhost:54321/rest/v1/ | jq '.info.title'
```

### Configuration

All test scripts use the following local Supabase configuration:

```
URL: http://localhost:54321
ANON_KEY: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsImlhdCI6MTYwMDAwMDAwMCwiZXhwIjoyMDAwMDAwMDAwLCJyb2xlIjoiYW5vbiIsInN1YiI6ImFub24ifQ.NYUVHJcTHyT2HARWAnFx6XDWXUli9XIepbB9JDR9Dy0
```

## API Endpoints Tested

### Salons Endpoint
```
POST   /rest/v1/salons              - Create salon
GET    /rest/v1/salons              - List salons
GET    /rest/v1/salons?id=eq.<id>   - Read single salon
PATCH  /rest/v1/salons?id=eq.<id>   - Update salon
DELETE /rest/v1/salons?id=eq.<id>   - Delete salon
```

### Services Endpoint
```
POST   /rest/v1/services            - Create service
GET    /rest/v1/services            - List services
GET    /rest/v1/services?id=eq.<id> - Read single service
PATCH  /rest/v1/services?id=eq.<id> - Update service
DELETE /rest/v1/services?id=eq.<id> - Delete service
```

### Appointments Endpoint
```
POST   /rest/v1/appointments            - Create appointment
GET    /rest/v1/appointments            - List appointments
GET    /rest/v1/appointments?id=eq.<id> - Read single appointment
PATCH  /rest/v1/appointments?id=eq.<id> - Update appointment
DELETE /rest/v1/appointments?id=eq.<id> - Delete appointment
```

## Example Test Run

```bash
$ bash test-local.sh

╔═══════════════════════════════════════════════════╗
║   LOCAL BARBER SALON MANAGEMENT - API TEST SUITE  ║
╚═══════════════════════════════════════════════════╝

══════════════════════════════════════════════════
1. Connection Test
══════════════════════════════════════════════════
✓ Local Supabase is running

══════════════════════════════════════════════════
3. SALONS CRUD Tests
══════════════════════════════════════════════════
✓ Create Salon (ID: ab986bb7...)
✓ Read Salon
✓ Update Salon

══════════════════════════════════════════════════
4. SERVICES CRUD Tests
══════════════════════════════════════════════════
✓ Create Service (ID: 9cee09dc...)
✓ Read Services (1 found)
✓ Update Service

══════════════════════════════════════════════════
6. APPOINTMENTS CRUD Tests
══════════════════════════════════════════════════
✓ Create Appointment (ID: aeb618c9...)
✓ Read Appointments (1 found)
✓ Update Appointment

══════════════════════════════════════════════════
Test Summary
══════════════════════════════════════════════════

Passed: 12
Failed: 0
Total: 12

🎉 All tests passed!
```

## RLS Policies

The tests require the following RLS policies to be enabled on the local Docker database:

### Applied to Local Database

```sql
-- SALONS
CREATE POLICY "allow_anyone_create_salons" ON public.salons FOR INSERT TO anon, authenticated WITH CHECK (true);
CREATE POLICY "allow_anyone_view_salons" ON public.salons FOR SELECT TO anon, authenticated USING (true);

-- SERVICES
CREATE POLICY "allow_anyone_create_services" ON public.services FOR INSERT TO anon, authenticated WITH CHECK (true);
CREATE POLICY "allow_anyone_view_services" ON public.services FOR SELECT TO anon, authenticated USING (true);

-- APPOINTMENTS
CREATE POLICY "allow_anyone_create_appointments" ON public.appointments FOR INSERT TO anon, authenticated WITH CHECK (true);
CREATE POLICY "allow_anyone_view_appointments" ON public.appointments FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "allow_update_appointments" ON public.appointments FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "allow_delete_appointments" ON public.appointments FOR DELETE TO authenticated USING (true);
```

These policies are automatically applied to the remote Supabase project via migrations in:
- `barber-backend/supabase/migrations/20260204000001_fix_appointment_creation_rls.sql`
- `barber-backend/supabase/migrations/20260204000002_fix_salons_rls.sql`

## Troubleshooting

### Connection Issues

**Error:** `Cannot connect to Supabase at http://localhost:54321`

**Solution:**
```bash
# Start Docker containers
docker compose up -d

# Wait 30 seconds and check health
docker compose ps

# Verify REST API is running
curl -s http://localhost:54321/rest/v1/ | head -c 100
```

### RLS Policy Errors

**Error:** `new row violates row-level security policy`

**Solution:**
```bash
# For local Docker, apply RLS policies manually:
docker exec supabase-db psql -U postgres -d postgres -c "
  CREATE POLICY \"allow_anyone_create_salons\" ON public.salons 
  FOR INSERT TO anon, authenticated WITH CHECK (true);"
```

### Empty API Responses

**Error:** `Status: 201 but empty response body`

**Solution:**
Add the `Prefer: return=representation` header to get the created record back:

```bash
curl -X POST http://localhost:54321/rest/v1/salons \
  -H "Prefer: return=representation" \
  -H "apikey: $ANON_KEY" \
  -H "Authorization: Bearer $ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{"name":"Test","slug":"test","owner_email":"owner@test.com"}'
```

## Test Data Schema

### Salon
```json
{
  "id": "uuid",
  "name": "string (required)",
  "slug": "string (required, unique)",
  "owner_email": "string (required)",
  "status": "string (default: 'active')",
  "created_at": "timestamp",
  "updated_at": "timestamp"
}
```

### Service
```json
{
  "id": "uuid",
  "salon_id": "uuid (required, FK to salons)",
  "name": "string (required)",
  "description": "string",
  "price": "numeric (required)",
  "duration": "integer in minutes (required)",
  "is_active": "boolean (default: true)",
  "created_at": "timestamp",
  "updated_at": "timestamp"
}
```

### Appointment
```json
{
  "id": "uuid",
  "salon_id": "uuid (required, FK to salons)",
  "staff_id": "uuid (FK to staff, optional)",
  "service_id": "uuid (FK to services, optional)",
  "customer_name": "string (required)",
  "customer_email": "string",
  "customer_phone": "string",
  "appointment_date": "date (required)",
  "appointment_time": "time (required)",
  "status": "string (default: 'Pending')",
  "amount": "numeric (required)",
  "notes": "string",
  "created_at": "timestamp",
  "updated_at": "timestamp"
}
```

## Running Tests in CI/CD

### GitHub Actions Example

```yaml
name: API Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    services:
      supabase:
        image: supabase/postgres:15
        # ... configuration ...
    
    steps:
      - uses: actions/checkout@v2
      - name: Run API Tests
        run: bash barber-backend/test-local.sh
```

## Contact & Support

For issues or questions about the test scripts, please refer to:
- API Documentation: `barber-frontend/src/services/`
- Migration Files: `barber-backend/supabase/migrations/`
- Type Definitions: `barber-frontend/src/types.ts`
