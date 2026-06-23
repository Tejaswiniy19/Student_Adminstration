#!/bin/bash

echo "╔══════════════════════════════════════════════════════════╗"
echo "║           🚀 Push to GitHub - Quick Setup                ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# Check if already has remote
if git remote | grep -q "origin"; then
    echo "⚠️  Remote 'origin' already exists!"
    echo ""
    git remote -v
    echo ""
    read -p "Remove and add new remote? (y/n): " REMOVE_REMOTE
    if [ "$REMOVE_REMOTE" = "y" ] || [ "$REMOVE_REMOTE" = "Y" ]; then
        git remote remove origin
        echo "✅ Removed existing remote"
    else
        echo "❌ Cancelled. Please remove remote manually: git remote remove origin"
        exit 1
    fi
fi

# Get GitHub username
echo "📝 Enter your GitHub username:"
read -p "Username: " GITHUB_USER

# Get repository name
echo ""
echo "📝 Enter repository name (e.g., SAMS-Platform):"
read -p "Repo name: " REPO_NAME

# Choose protocol
echo ""
echo "🔐 Choose authentication method:"
echo "  1) HTTPS (easier, requires token)"
echo "  2) SSH (recommended, requires SSH key)"
read -p "Choice (1/2): " AUTH_CHOICE

if [ "$AUTH_CHOICE" = "2" ]; then
    REMOTE_URL="git@github.com:$GITHUB_USER/$REPO_NAME.git"
else
    REMOTE_URL="https://github.com/$GITHUB_USER/$REPO_NAME.git"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Repository URL: $REMOTE_URL"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Confirm
read -p "📋 Have you created the repo on GitHub? (y/n): " REPO_CREATED

if [ "$REPO_CREATED" != "y" ] && [ "$REPO_CREATED" != "Y" ]; then
    echo ""
    echo "⚠️  Please create the repository first!"
    echo "   1. Go to: https://github.com/new"
    echo "   2. Name: $REPO_NAME"
    echo "   3. Don't initialize with README/gitignore"
    echo "   4. Click 'Create repository'"
    echo ""
    read -p "Press Enter after creating the repo..."
fi

# Add remote
echo ""
echo "🔗 Adding remote..."
git remote add origin "$REMOTE_URL"
echo "✅ Remote added"

# Rename branch to main
echo ""
echo "🌿 Renaming branch to main..."
git branch -M main
echo "✅ Branch renamed"

# Push
echo ""
echo "🚀 Pushing to GitHub..."
echo ""
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║              🎉 PUSH SUCCESSFUL! 🎉                      ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo ""
    echo "✅ Your code is now on GitHub!"
    echo ""
    echo "🌐 View your repository:"
    echo "   https://github.com/$GITHUB_USER/$REPO_NAME"
    echo ""
    echo "📊 Repository includes:"
    echo "   • 104 files"
    echo "   • Complete frontend & backend"
    echo "   • Deployment documentation"
    echo "   • Vercel configuration"
    echo ""
else
    echo ""
    echo "❌ Push failed!"
    echo ""
    echo "Common solutions:"
    echo "  1. Check your GitHub credentials"
    echo "  2. Create Personal Access Token: https://github.com/settings/tokens"
    echo "  3. Or set up SSH key: https://github.com/settings/keys"
    echo ""
fi
