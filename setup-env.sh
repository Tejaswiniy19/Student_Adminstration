#!/bin/bash

# SAMS Platform - Environment Setup Script
# This script helps you set up environment variables for Vercel deployment

echo "🚀 SAMS Platform - Environment Variable Setup"
echo "=============================================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to check if vercel CLI is available
check_vercel_cli() {
    if ! command -v npx &> /dev/null; then
        echo -e "${RED}❌ npx not found. Please install Node.js first.${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ Vercel CLI available${NC}"
}

# Backend setup
setup_backend_env() {
    echo ""
    echo "📦 Setting up Backend Environment Variables"
    echo "==========================================="

    cd backend || exit

    # DATABASE_URL
    echo ""
    echo -e "${YELLOW}1. DATABASE_URL${NC}"
    echo "   Your PostgreSQL connection string"
    echo "   Example: postgresql://user:pass@host.neon.tech:5432/dbname"
    read -p "   Enter DATABASE_URL: " DATABASE_URL
    echo "$DATABASE_URL" | npx vercel env add DATABASE_URL production --yes

    # JWT_SECRET
    echo ""
    echo -e "${YELLOW}2. JWT_SECRET${NC}"
    echo "   Secure random string for JWT tokens"
    read -p "   Do you want to auto-generate? (y/n): " GENERATE_JWT
    if [ "$GENERATE_JWT" = "y" ] || [ "$GENERATE_JWT" = "Y" ]; then
        JWT_SECRET=$(openssl rand -base64 32)
        echo "   Generated: $JWT_SECRET"
        echo "$JWT_SECRET" | npx vercel env add JWT_SECRET production --yes
    else
        read -p "   Enter JWT_SECRET: " JWT_SECRET
        echo "$JWT_SECRET" | npx vercel env add JWT_SECRET production --yes
    fi

    # NODE_ENV
    echo ""
    echo -e "${YELLOW}3. NODE_ENV${NC}"
    echo "production" | npx vercel env add NODE_ENV production --yes
    echo "   Set to: production"

    # FRONTEND_URL
    echo ""
    echo -e "${YELLOW}4. FRONTEND_URL${NC}"
    echo "   Default: https://frontend-seven-tan-30.vercel.app"
    read -p "   Press Enter to use default or type custom URL: " FRONTEND_URL
    if [ -z "$FRONTEND_URL" ]; then
        FRONTEND_URL="https://frontend-seven-tan-30.vercel.app"
    fi
    echo "$FRONTEND_URL" | npx vercel env add FRONTEND_URL production --yes
    echo "   Set to: $FRONTEND_URL"

    echo ""
    echo -e "${GREEN}✓ Backend environment variables configured${NC}"

    # Run migrations
    echo ""
    echo -e "${YELLOW}Would you like to run Prisma migrations now? (y/n)${NC}"
    read -p "   " RUN_MIGRATIONS
    if [ "$RUN_MIGRATIONS" = "y" ] || [ "$RUN_MIGRATIONS" = "Y" ]; then
        echo "   Installing dependencies..."
        npm install
        echo "   Generating Prisma Client..."
        npx prisma generate
        echo "   Running migrations..."
        DATABASE_URL="$DATABASE_URL" npx prisma migrate deploy
        echo -e "${GREEN}✓ Migrations completed${NC}"
    fi

    # Redeploy
    echo ""
    echo -e "${YELLOW}Redeploying backend...${NC}"
    npx vercel --prod --yes
    echo -e "${GREEN}✓ Backend redeployed${NC}"

    cd ..
}

# Frontend setup
setup_frontend_env() {
    echo ""
    echo "🎨 Setting up Frontend Environment Variables"
    echo "==========================================="

    cd frontend || exit

    # VITE_API_URL
    echo ""
    echo -e "${YELLOW}1. VITE_API_URL${NC}"
    echo "   Default: https://backend-weld-seven-41.vercel.app"
    read -p "   Press Enter to use default or type custom URL: " VITE_API_URL
    if [ -z "$VITE_API_URL" ]; then
        VITE_API_URL="https://backend-weld-seven-41.vercel.app"
    fi
    echo "$VITE_API_URL" | npx vercel env add VITE_API_URL production --yes
    echo "   Set to: $VITE_API_URL"

    echo ""
    echo -e "${GREEN}✓ Frontend environment variables configured${NC}"

    # Redeploy
    echo ""
    echo -e "${YELLOW}Redeploying frontend...${NC}"
    npx vercel --prod --yes
    echo -e "${GREEN}✓ Frontend redeployed${NC}"

    cd ..
}

# Main execution
main() {
    check_vercel_cli

    echo ""
    echo "This script will guide you through setting up environment variables"
    echo "for both backend and frontend deployments."
    echo ""
    read -p "Press Enter to continue..."

    setup_backend_env
    setup_frontend_env

    echo ""
    echo "=============================================="
    echo -e "${GREEN}🎉 Setup Complete!${NC}"
    echo "=============================================="
    echo ""
    echo "Your applications are now configured:"
    echo "  Backend:  https://backend-weld-seven-41.vercel.app"
    echo "  Frontend: https://frontend-seven-tan-30.vercel.app"
    echo ""
    echo "Next steps:"
    echo "  1. Test backend health: curl https://backend-weld-seven-41.vercel.app/api/auth/health"
    echo "  2. Visit frontend: https://frontend-seven-tan-30.vercel.app"
    echo "  3. Try registration/login flow"
    echo ""
    echo "View logs:"
    echo "  Backend:  npx vercel logs backend --prod"
    echo "  Frontend: npx vercel logs frontend --prod"
    echo ""
}

main
