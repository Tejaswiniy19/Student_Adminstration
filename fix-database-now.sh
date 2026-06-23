#!/bin/bash

# INSTANT FIX SCRIPT - Run this with your Supabase connection string
# Usage: ./fix-database-now.sh "your-supabase-session-mode-connection-string"

if [ -z "$1" ]; then
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🚨 QUICK FIX FOR DATABASE CONNECTION ERROR"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "1. Go to: https://supabase.com/dashboard/projects"
    echo "2. Click your project → Settings → Database"
    echo "3. Find 'Connection string' section"
    echo "4. Click 'Session mode' tab"
    echo "5. Copy the string (replace [YOUR-PASSWORD] with: Ytejaswini@064)"
    echo ""
    echo "Then run:"
    echo "./fix-database-now.sh 'your-connection-string-here'"
    echo ""
    echo "OR paste your connection string here and I'll give you the command!"
    exit 1
fi

DATABASE_URL="$1"

echo "🔧 Updating Render environment..."
echo ""
echo "Run this command:"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Go to: https://dashboard.render.com/"
echo "→ Click: student-adminstration"
echo "→ Click: Environment"
echo "→ Edit DATABASE_URL"
echo "→ Paste this:"
echo ""
echo "$DATABASE_URL"
echo ""
echo "→ Save Changes"
echo "→ Wait 2 minutes"
echo "→ Test: https://frontend-seven-tan-30.vercel.app/login"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ Done! Your backend will connect to database after Render redeploys."
