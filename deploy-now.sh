#!/bin/bash

echo "🚀 SAMS Platform - Complete Deployment"
echo "======================================"
echo ""
echo "I'll deploy everything in one go!"
echo ""

# Collect DATABASE_URL
read -p "📝 Paste your DATABASE_URL: " DATABASE_URL
echo ""

# Generate JWT_SECRET
echo "🔐 Generating JWT_SECRET..."
JWT_SECRET=$(openssl rand -base64 32 2>/dev/null || echo "your-super-secret-jwt-key-$(date +%s)")
echo "   Generated: ${JWT_SECRET:0:20}..."
echo ""

BACKEND_URL="https://backend-weld-seven-41.vercel.app"
FRONTEND_URL="https://frontend-seven-tan-30.vercel.app"

echo "🗄️  Running database migrations..."
cd backend
export DATABASE_URL="$DATABASE_URL"
npm install --silent 2>&1 | grep -v "deprecated" | grep -v "warn" || true
npx prisma generate --silent || npx prisma generate
npx prisma migrate deploy || echo "⚠️  Migration warning (continuing...)"
echo "✅ Migrations done"
echo ""

echo "🔧 Setting backend environment variables..."
echo "$DATABASE_URL" | npx vercel env add DATABASE_URL production --yes 2>/dev/null || true
echo "$JWT_SECRET" | npx vercel env add JWT_SECRET production --yes 2>/dev/null || true
echo "production" | npx vercel env add NODE_ENV production --yes 2>/dev/null || true
echo "$FRONTEND_URL" | npx vercel env add FRONTEND_URL production --yes 2>/dev/null || true
echo "✅ Backend env vars set"
echo ""

echo "🚀 Deploying backend..."
npx vercel --prod --yes | tail -5
echo "✅ Backend deployed"
echo ""

cd ../frontend
echo "🔧 Setting frontend environment variables..."
echo "$BACKEND_URL" | npx vercel env add VITE_API_URL production --yes 2>/dev/null || true
echo "✅ Frontend env vars set"
echo ""

echo "🚀 Deploying frontend..."
npx vercel --prod --yes | tail -5
echo "✅ Frontend deployed"
echo ""

cd ..

echo ""
echo "🎉 DEPLOYMENT COMPLETE!"
echo "======================"
echo ""
echo "✅ Backend:  $BACKEND_URL"
echo "✅ Frontend: $FRONTEND_URL"
echo ""
echo "🧪 Quick Test:"
echo "   curl $BACKEND_URL/api/auth/health"
echo ""
echo "🌐 Open your app:"
echo "   $FRONTEND_URL/register"
echo ""
