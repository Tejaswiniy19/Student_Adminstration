# ⚡ Quick Deployment Reference

## 🌐 Your Live URLs

| Component | URL |
|-----------|-----|
| **Frontend** | https://frontend-seven-tan-30.vercel.app |
| **Backend** | https://backend-weld-seven-41.vercel.app |
| **Backend Dashboard** | https://vercel.com/dammuvinay143-3867s-projects/backend |
| **Frontend Dashboard** | https://vercel.com/dammuvinay143-3867s-projects/frontend |

---

## 🚨 Critical: Environment Variables

### ⚠️ Your apps won't work until you set these!

#### Backend Env Vars (4 required)
```bash
cd backend
npx vercel env add DATABASE_URL production    # PostgreSQL connection string
npx vercel env add JWT_SECRET production      # Random secret key
npx vercel env add NODE_ENV production        # "production"
npx vercel env add FRONTEND_URL production    # https://frontend-seven-tan-30.vercel.app
npx vercel --prod
```

#### Frontend Env Vars (1 required)
```bash
cd frontend
npx vercel env add VITE_API_URL production    # https://backend-weld-seven-41.vercel.app
npx vercel --prod
```

---

## 🗄️ Database Setup (One-time)

### Get a Free Database
- **Neon** (Recommended): https://neon.tech
- **Supabase**: https://supabase.com
- **Railway**: https://railway.app

### Run Migrations
```bash
cd backend
export DATABASE_URL="your-postgres-url"
npm install
npx prisma generate
npx prisma migrate deploy
```

---

## 🧪 Quick Test

### Test Backend
```bash
curl https://backend-weld-seven-41.vercel.app/api/auth/health
```
Expected: `{"status":"ok"}`

### Test Frontend
Open: https://frontend-seven-tan-30.vercel.app/register

---

## 🔄 Redeploy Commands

```bash
# Backend
cd backend && npx vercel --prod

# Frontend
cd frontend && npx vercel --prod

# Both
cd backend && npx vercel --prod && cd ../frontend && npx vercel --prod
```

---

## 📊 View Logs

```bash
npx vercel logs backend --prod
npx vercel logs frontend --prod
```

---

## 🛠️ Automated Setup

Run the interactive setup script:
```bash
./setup-env.sh
```

---

## 📋 Setup Checklist

- [ ] Get DATABASE_URL from Neon/Supabase/Railway
- [ ] Set backend environment variables
- [ ] Run Prisma migrations
- [ ] Redeploy backend
- [ ] Set frontend environment variable
- [ ] Redeploy frontend
- [ ] Test registration flow
- [ ] Test login flow

---

## 🆘 Common Fixes

| Problem | Solution |
|---------|----------|
| CORS error | Set FRONTEND_URL in backend, redeploy |
| Database error | Check DATABASE_URL, run migrations |
| Blank page | Check VITE_API_URL in frontend |
| 500 errors | Check backend logs: `npx vercel logs backend --prod` |

---

## 📚 Full Documentation

- **Detailed Guide**: [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)
- **Current Status**: [DEPLOYMENT_STATUS.md](DEPLOYMENT_STATUS.md)
- **App Workflow**: [WORKFLOW_GUIDE.md](WORKFLOW_GUIDE.md)
- **Troubleshooting**: [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

---

## 🎯 Status: Deployed

✅ Backend deployed  
✅ Frontend deployed  
⏳ Awaiting configuration (env vars + database)

Once configured → **🎉 Fully Operational**
