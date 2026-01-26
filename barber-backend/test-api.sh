#!/bin/bash

# Test API endpoints for barber salon management

BASE_URL="http://localhost:3000"
SUPABASE_URL="http://localhost:54321"
ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxvY2FsaG9zdCIsInJvbGUiOiJhbm9uIiwiaWF0IjoxNjc4OTAwMDAwLCJleHAiOjE2NzkyMDAwMDB9.v2aYJ7v3Z7U1a2b3c4d5e6f7g8h9i0j1k2l3m4n5o6p"

echo "🧪 Testing Barber Salon Management API"
echo "========================================"
echo ""

# Test 1: Create salon
echo "📌 Test 1: Create Salon"
echo "POST $SUPABASE_URL/rest/v1/salons"
SALON_RESPONSE=$(curl -s -X POST "$SUPABASE_URL/rest/v1/salons" \
  -H "apikey: $ANON_KEY" \
  -H "Authorization: Bearer $ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Main Barber Shop",
    "owner_email": "owner@barbershop.com"
  }')

echo "$SALON_RESPONSE" | jq '.' 2>/dev/null || echo "$SALON_RESPONSE"
SALON_ID=$(echo "$SALON_RESPONSE" | jq -r '.[0].id' 2>/dev/null || echo "error")
echo "Salon ID: $SALON_ID"
echo ""

# Test 2: Create owner user account
echo "📌 Test 2: Create Owner Account"
echo "This would be done via Supabase Auth UI in production"
echo ""

# Test 3: Create staff via Edge Function
echo "📌 Test 3: Create Staff via Edge Function"
echo "POST http://localhost:54321/functions/v1/create-staff"

STAFF_RESPONSE=$(curl -s -X POST "http://localhost:54321/functions/v1/create-staff" \
  -H "Authorization: Bearer $ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "fullName": "John Barber",
    "email": "john@barbershop.com",
    "password": "securepass123",
    "specialty": "Haircut",
    "salonId": "'$SALON_ID'"
  }')

echo "$STAFF_RESPONSE" | jq '.' 2>/dev/null || echo "$STAFF_RESPONSE"
echo ""

# Test 4: Fetch staff
echo "📌 Test 4: Fetch Staff"
echo "GET $SUPABASE_URL/rest/v1/staff?salon_id=eq.$SALON_ID"

FETCH_RESPONSE=$(curl -s -X GET "$SUPABASE_URL/rest/v1/staff?salon_id=eq.$SALON_ID" \
  -H "apikey: $ANON_KEY" \
  -H "Authorization: Bearer $ANON_KEY")

echo "$FETCH_RESPONSE" | jq '.' 2>/dev/null || echo "$FETCH_RESPONSE"
echo ""

echo "✅ Testing Complete!"
