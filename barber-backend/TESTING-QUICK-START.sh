#!/usr/bin/env bash

###############################################################
# Quick Start Guide - API Testing
# Run this script to understand how to test all endpoints
###############################################################

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║   BARBER SALON MANAGEMENT API - QUICK START GUIDE        ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

echo "📋 AVAILABLE TEST SCRIPTS:"
echo "   1. test-local.sh              - Local Docker Supabase testing (RECOMMENDED)"
echo "   2. test-comprehensive.py      - Advanced Python test suite"
echo "   3. test-all-endpoints.sh      - Extended test coverage"
echo ""

echo "🚀 QUICK START (3 steps):"
echo ""
echo "Step 1: Start Docker Containers"
echo "   $ cd /home/montassar/Desktop/reservi"
echo "   $ docker compose up -d"
echo "   $ sleep 30  # Wait for services to start"
echo ""

echo "Step 2: Run Tests"
echo "   $ cd barber-backend"
echo "   $ bash test-local.sh"
echo ""

echo "Step 3: Review Results"
echo "   ✓ Check for 'All tests passed!'"
echo "   ✓ Verify HTTP status codes"
echo "   ✓ Review created resource IDs"
echo ""

echo "═══════════════════════════════════════════════════════════"
echo ""

echo "🔌 MANUAL API TESTING WITH CURL:"
echo ""

ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsImlhdCI6MTYwMDAwMDAwMCwiZXhwIjoyMDAwMDAwMDAwLCJyb2xlIjoiYW5vbiIsInN1YiI6ImFub24ifQ.NYUVHJcTHyT2HARWAnFx6XDWXUli9XIepbB9JDR9Dy0"
URL="http://localhost:54321/rest/v1"

echo "Create a Salon:"
echo "   curl -X POST $URL/salons \\"
echo "     -H 'apikey: $ANON_KEY' \\"
echo "     -H 'Authorization: Bearer $ANON_KEY' \\"
echo "     -H 'Content-Type: application/json' \\"
echo "     -H 'Prefer: return=representation' \\"
echo "     -d '{\"name\":\"My Salon\",\"slug\":\"my-salon\",\"owner_email\":\"owner@test.com\"}'"
echo ""

echo "Read All Salons:"
echo "   curl -X GET $URL/salons \\"
echo "     -H 'apikey: $ANON_KEY' \\"
echo "     -H 'Authorization: Bearer $ANON_KEY'"
echo ""

echo "Create an Appointment:"
echo "   curl -X POST $URL/appointments \\"
echo "     -H 'apikey: $ANON_KEY' \\"
echo "     -H 'Authorization: Bearer $ANON_KEY' \\"
echo "     -H 'Content-Type: application/json' \\"
echo "     -H 'Prefer: return=representation' \\"
echo "     -d '{"
echo "       \"salon_id\": \"<salon-uuid>\","
echo "       \"customer_name\": \"John Doe\","
echo "       \"customer_email\": \"john@example.com\","
echo "       \"appointment_date\": \"2026-02-10\","
echo "       \"appointment_time\": \"14:00:00\","
echo "       \"amount\": 30.00"
echo "     }'"
echo ""

echo "═══════════════════════════════════════════════════════════"
echo ""

echo "✨ KEY FEATURES TESTED:"
echo "   ✓ POST   - Create records (Salons, Services, Appointments)"
echo "   ✓ GET    - Read records with filtering"
echo "   ✓ PATCH  - Update records"
echo "   ✓ DELETE - Delete records"
echo "   ✓ RLS    - Row Level Security enforcement"
echo "   ✓ Auth   - Authentication with ANON_KEY"
echo "   ✓ Relations - Foreign key constraints"
echo ""

echo "📊 EXPECTED TEST RESULTS:"
echo "   Total Tests: ~12-15"
echo "   Pass Rate: 100%"
echo "   Execution Time: ~10-15 seconds"
echo ""

echo "🔍 ENDPOINTS COVERED:"
echo "   • /rest/v1/salons"
echo "   • /rest/v1/services"
echo "   • /rest/v1/appointments"
echo "   • /rest/v1/staff"
echo ""

echo "📝 LOG FILES:"
echo "   Test output is displayed in terminal (no log file)"
echo "   Redirect output: bash test-local.sh > test-results.log"
echo ""

echo "🆘 TROUBLESHOOTING:"
echo "   If tests fail, check:"
echo "   1. Docker containers are running: docker compose ps"
echo "   2. REST API is responding: curl http://localhost:54321/rest/v1/"
echo "   3. RLS policies are applied (see TEST-SUITE-README.md)"
echo ""

echo "═══════════════════════════════════════════════════════════"
echo ""
echo "📖 For more details, see: TEST-SUITE-README.md"
echo ""
