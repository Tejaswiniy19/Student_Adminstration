# 🚀 Vercel Deployment Guide

## Prerequisites
- [ ] Vercel account (sign up at https://vercel.com)
- [ ] PostgreSQL database (recommended: Neon, Supabase, or Railway)
- [ ] Git repository (optional but recommended)

---

## 📋 Deployment Strategy

This project uses a **monorepo structure** with:
- **Backend**: Node.js/Express API (serverless functions)
- **Frontend**: React/Vite SPA (static site)

We'll deploy them as **two separate Vercel projects** for optimal performance.

---

## 🗄️ Step 1: Set Up Database

### Option A: Neon (Recommended - Free Tier Available)
1. Go to https://neon.tech
2. Create a new project
3. Copy the connection string (looks like: `postgresql://user:pass@host.neon.tech/dbname`)

### Option B: Supabase
1. Go to https://supabase.com
2. Create a new project
3. Get connection string from Settings → Database

### Option C: Railway
1. Go to https://railway.app
2. Create PostgreSQL database
3. Copy connection string

**Save your DATABASE_URL** - you'll need it in Step 3!

---

## 🔧 Step 2: Deploy Backend API

### 2.1 Navigate to Backend Directory
```bash
cd backend
```

### 2.2 Initialize Vercel Project
```bash
vercel
```

**Answer the prompts:**
```
? Set up and deploy "backend"? [Y/n] y
? Which scope? Your account
? Link to existing project? [y/N] n
? What's your project's name? sams-backend
? In which directory is your code located? ./
? Want to modify these settings? [y/N] n
```

### 2.3 Set Environment Variables
```bash
# Set DATABASE_URL
vercel env add DATABASE_URL production

# When prompted, paste your PostgreSQL connection string
# Example: postgresql://user:pass@host.neon.tech/dbname

# Set JWT_SECRET
vercel env add JWT_SECRET production
# Paste a long random string (generate one: openssl rand -base64 32)

# Set NODE_ENV
vercel env add NODE_ENV production
# Enter: production
```

### 2.4 Run Prisma Migration
```bash
# Install dependencies first
npm install

# Generate Prisma Client
npx prisma generate

# Run migrations (use your DATABASE_URL)
DATABASE_URL="your-connection-string" npx prisma migrate deploy
```

### 2.5 Deploy Backend
```bash
vercel --prod
```

**Save the deployment URL!** It will look like:
```
https://sams-backend-xxxxx.vercel.app
```

---

## 🎨 Step 3: Deploy Frontend

### 3.1 Navigate to Frontend Directory
```bash
cd ../frontend
```

### 3.2 Create Environment File
```bash
# Create .env file
echo "VITE_API_URL=https://sams-backend-xxxxx.vercel.app" > .env
```

**Replace `xxxxx` with your actual backend URL from Step 2.5!**

### 3.3 Initialize Vercel Project
```bash
vercel
```

**Answer the prompts:**
```
? Set up and deploy "frontend"? [Y/n] y
? Which scope? Your account
? Link to existing project? [y/N] n
? What's your project's name? sams-frontend
? In which directory is your code located? ./
? Want to modify these settings? [y/N] n
```

### 3.4 Set Environment Variables
```bash
# Set VITE_API_URL
vercel env add VITE_API_URL production

# Paste your backend URL from Step 2.5
# Example: https://sams-backend-xxxxx.vercel.app
```

### 3.5 Deploy Frontend
```bash
vercel --prod
```

**Save the deployment URL!** It will look like:
```
https://sams-frontend-xxxxx.vercel.app
```

---

## 🔗 Step 4: Connect Backend to Frontend

### 4.1 Update Backend CORS Settings
```bash
cd ../backend

# Add FRONTEND_URL environment variable
vercel env add FRONTEND_URL production

# Paste your frontend URL from Step 3.5
# Example: https://sams-frontend-xxxxx.vercel.app
```

### 4.2 Redeploy Backend
```bash
vercel --prod
```

---

## 🧪 Step 5: Test Your Deployment

### 5.1 Check Backend Health
```bash
curl https://sams-backend-xxxxx.vercel.app/api/auth/health
```

Should return: `{"status":"ok"}`

### 5.2 Test Frontend
1. Open your frontend URL: `https://sams-frontend-xxxxx.vercel.app`
2. Navigate to `/register`
3. Try creating an account
4. Check if login works

---

## 🎯 Quick Deploy (Alternative - Single Command)

If you're already in the root directory and want to deploy everything at once:

### Backend
```bash
cd backend
vercel env add DATABASE_URL production
vercel env add JWT_SECRET production
vercel env add NODE_ENV production
npx prisma migrate deploy
vercel --prod
cd ..
```

### Frontend
```bash
cd frontend
vercel env add VITE_API_URL production
vercel --prod
cd ..
```

---

## 📝 Environment Variables Summary

### Backend (sams-backend)
```
DATABASE_URL=postgresql://user:pass@host/db
JWT_SECRET=your-random-secret-key
NODE_ENV=production
FRONTEND_URL=https://sams-frontend-xxxxx.vercel.app
```

### Frontend (sams-frontend)
```
VITE_API_URL=https://sams-backend-xxxxx.vercel.app
```

---

## 🔧 Troubleshooting

### Issue: "Prisma Client not found"
**Solution:**
```bash
cd backend
npm install @prisma/client
npx prisma generate
vercel --prod
```

### Issue: "CORS Error"
**Solution:**
1. Verify FRONTEND_URL is set correctly in backend
2. Redeploy backend: `vercel --prod`
3. Check backend logs: `vercel logs`

### Issue: "Database connection failed"
**Solution:**
1. Verify DATABASE_URL is correct
2. Check if database allows connections from Vercel IPs
3. Test connection locally first

### Issue: Frontend shows blank page
**Solution:**
1. Check browser console (F12)
2. Verify VITE_API_URL is correct
3. Check Network tab for failed requests
4. View deployment logs: `vercel logs`

### Issue: "Function execution timeout"
**Solution:**
- Vercel free tier has 10s timeout limit
- Optimize slow queries
- Consider upgrading to Pro plan

---

## 📊 Post-Deployment Checklist

- [ ] Backend API responds at `/api/auth/health`
- [ ] Frontend loads without errors
- [ ] Registration form works
- [ ] Login redirects to dashboard
- [ ] CORS is configured correctly
- [ ] Database migrations are applied
- [ ] Environment variables are set
- [ ] Custom domains configured (optional)

---

## 🌐 Custom Domains (Optional)

### Add Custom Domain to Frontend
```bash
cd frontend
vercel domains add yourdomain.com
```

### Add Custom Domain to Backend
```bash
cd backend
vercel domains add api.yourdomain.com
```

**Then update environment variables:**
```bash
# Update backend FRONTEND_URL
vercel env add FRONTEND_URL production
# Enter: https://yourdomain.com

# Update frontend VITE_API_URL
cd ../frontend
vercel env add VITE_API_URL production
# Enter: https://api.yourdomain.com
```

---

## 🔄 Redeployment

### Update Backend
```bash
cd backend
vercel --prod
```

### Update Frontend
```bash
cd frontend
vercel --prod
```

### Update Both
```bash
vercel --prod --cwd backend && vercel --prod --cwd frontend
```

---

## 📈 Monitoring

### View Logs
```bash
# Backend logs
vercel logs sams-backend --prod

# Frontend logs
vercel logs sams-frontend --prod
```

### View Deployment Info
```bash
vercel inspect sams-backend
vercel inspect sams-frontend
```

---

## 💰 Cost Considerations

### Vercel Free Tier Includes:
- ✅ Unlimited deployments
- ✅ 100GB bandwidth/month
- ✅ Serverless function execution
- ✅ Automatic HTTPS
- ✅ DDoS protection

### When to Upgrade:
- Need more than 100GB bandwidth
- Require faster build times
- Need team collaboration
- Want analytics/monitoring

---

## 🎉 Success!

Your SAMS Platform is now live on Vercel!

**Backend:** https://sams-backend-xxxxx.vercel.app  
**Frontend:** https://sams-frontend-xxxxx.vercel.app

Share your frontend URL with users to start accepting applications!

---

## 📚 Additional Resources

- [Vercel Documentation](https://vercel.com/docs)
- [Prisma Deployment](https://www.prisma.io/docs/guides/deployment)
- [Environment Variables](https://vercel.com/docs/concepts/projects/environment-variables)
- [Custom Domains](https://vercel.com/docs/concepts/projects/domains)
