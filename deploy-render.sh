#!/bin/bash

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                                                              ║"
echo "║      🚀 Render + Vercel Deployment - Automated Setup        ║"
echo "║                                                              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}STEP 1: Render Backend Deployment${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "To deploy backend to Render:"
echo ""
echo "1. Go to: https://dashboard.render.com/"
echo "2. Sign up/Login with GitHub"
echo "3. Click 'New +' → 'Web Service'"
echo "4. Connect repository: Tejaswiniy19/Student_Adminstration"
echo ""
echo "5. Configure:"
echo "   Name:           sams-backend"
echo "   Region:         Oregon (US West)"
echo "   Branch:         main"
echo "   Root Directory: backend"
echo "   Build Command:  npm install && npx prisma generate"
echo "   Start Command:  node src/server.js"
echo ""
echo "6. Add Environment Variables:"
echo "   NODE_ENV=production"
echo "   DATABASE_URL=postgresql://postgres:Ytejaswini%40064@db.cfupssvxtjtobygpfzna.supabase.co:5432/postgres"
echo "   JWT_SECRET=NW1EA8vP7priWgjADL5VgUXk7d/qKxqTi9EbH7rlS2c="
echo "   FRONTEND_URL=https://frontend-seven-tan-30.vercel.app"
echo ""
echo "7. Click 'Create Web Service'"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
read -p "Press Enter after Render deployment completes..."

echo ""
echo -e "${YELLOW}📝 Enter your Render backend URL:${NC}"
echo "   (e.g., https://sams-backend-xxxx.onrender.com)"
read -p "Render URL: " RENDER_URL

if [ -z "$RENDER_URL" ]; then
    echo -e "${RED}❌ No URL provided. Exiting.${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}STEP 2: Update Frontend Configuration${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

cd frontend || exit 1

echo "→ Removing old VITE_API_URL..."
npx vercel env rm VITE_API_URL production 2>/dev/null || true

echo "→ Adding new Render backend URL..."
echo "$RENDER_URL" | npx vercel env add VITE_API_URL production --yes

echo "→ Redeploying frontend to Vercel..."
npx vercel --prod --yes

cd ..

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${YELLOW}STEP 3: Update Backend CORS${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "⚠️  IMPORTANT: Update FRONTEND_URL on Render"
echo ""
echo "1. Go to: https://dashboard.render.com/"
echo "2. Select your 'sams-backend' service"
echo "3. Click 'Environment' tab"
echo "4. Edit FRONTEND_URL to: https://frontend-seven-tan-30.vercel.app"
echo "5. Click 'Save Changes'"
echo "6. Render will auto-redeploy (wait 2-3 minutes)"
echo ""
read -p "Press Enter after updating CORS..."

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}✅ DEPLOYMENT COMPLETE!${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🌐 Your Application:"
echo "   Frontend: https://frontend-seven-tan-30.vercel.app"
echo "   Backend:  $RENDER_URL"
echo ""
echo "🧪 Test Now:"
echo "   1. Open: https://frontend-seven-tan-30.vercel.app/register"
echo "   2. Register a test account"
echo "   3. Login and explore!"
echo ""
echo "📊 Dashboards:"
echo "   Render:  https://dashboard.render.com/"
echo "   Vercel:  https://vercel.com/dammuvinay143-3867s-projects/frontend"
echo "   GitHub:  https://github.com/Tejaswiniy19/Student_Adminstration"
echo ""
echo "⚠️  Note: Render free tier sleeps after 15min inactivity"
echo "   First request after sleep takes ~30 seconds"
echo ""
