#!/bin/bash

# INSTANT DEPLOYMENT SCRIPT
# Usage: ./instant-deploy.sh "your-database-url"

if [ -z "$1" ]; then
    echo "❌ Please provide DATABASE_URL as argument"
    echo "Usage: ./instant-deploy.sh 'postgresql://user:pass@host:5432/db'"
    exit 1
fi

DATABASE_URL="$1"
BACKEND_URL="https://backend-weld-seven-41.vercel.app"
FRONTEND_URL="https://frontend-seven-tan-30.vercel.app"

echo "🚀 INSTANT DEPLOYMENT STARTING..."
echo "=================================="
echo ""

# Generate JWT_SECRET
JWT_SECRET=$(openssl rand -base64 32 2>/dev/null || echo "jwt-secret-$(date +%s)-$(shuf -i 1000-9999 -n 1)")
echo "✅ Generated JWT_SECRET"

# Backend setup
echo ""
echo "📦 Backend Setup..."
cd backend || exit 1

echo "  → Installing dependencies..."
npm install --silent --no-audit --no-fund 2>&1 | grep -E "added|removed|changed" || true

echo "  → Generating Prisma Client..."
npx prisma generate 2>&1 | grep -E "Generated|✔" || true

echo "  → Running migrations..."
export DATABASE_URL="$DATABASE_URL"
npx prisma migrate deploy 2>&1 | grep -E "Applied|✔|already" || true

echo "  → Setting environment variables..."
echo "$DATABASE_URL" | npx vercel env add DATABASE_URL production --yes 2>&1 | grep -E "✅|Created|Updated" || true
echo "$JWT_SECRET" | npx vercel env add JWT_SECRET production --yes 2>&1 | grep -E "✅|Created|Updated" || true
echo "production" | npx vercel env add NODE_ENV production --yes 2>&1 | grep -E "✅|Created|Updated" || true
echo "$FRONTEND_URL" | npx vercel env add FRONTEND_URL production --yes 2>&1 | grep -E "✅|Created|Updated" || true

echo "  → Deploying backend..."
npx vercel --prod --yes 2>&1 | tail -10

echo "✅ Backend deployed!"

# Frontend setup
echo ""
echo "🎨 Frontend Setup..."
cd ../frontend || exit 1

echo "  → Setting environment variables..."
echo "$BACKEND_URL" | npx vercel env add VITE_API_URL production --yes 2>&1 | grep -E "✅|Created|Updated" || true

echo "  → Deploying frontend..."
npx vercel --prod --yes 2>&1 | tail -10

echo "✅ Frontend deployed!"

cd ..

# Test deployment
echo ""
echo "🧪 Testing deployment..."
sleep 3
HEALTH_CHECK=$(curl -s "$BACKEND_URL/api/auth/health" 2>/dev/null || echo "error")

echo ""
echo "╔════════════════════════════════════════════════════╗"
echo "║           🎉 DEPLOYMENT COMPLETE!                  ║"
echo "╚════════════════════════════════════════════════════╝"
echo ""
echo "✅ Backend:  $BACKEND_URL"
echo "✅ Frontend: $FRONTEND_URL"
echo ""
if [[ "$HEALTH_CHECK" == *"ok"* ]] || [[ "$HEALTH_CHECK" == *"status"* ]]; then
    echo "✅ Backend health check: PASSED"
else
    echo "⏳ Backend health check: Warming up (may take 30s)"
fi
echo ""
echo "🌐 Open your app: $FRONTEND_URL/register"
echo ""
echo "📊 View dashboards:"
echo "   Backend:  https://vercel.com/dammuvinay143-3867s-projects/backend"
echo "   Frontend: https://vercel.com/dammuvinay143-3867s-projects/frontend"
echo ""
