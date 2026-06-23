# 🚀 Render + Vercel Deployment Guide

## Quick Deploy - Complete Setup

Your SAMS Platform will be deployed with:
- **Backend:** Render (Node.js server)
- **Frontend:** Vercel (Static hosting)
- **Database:** Supabase PostgreSQL

---

## 📋 Step 1: Deploy Backend to Render

### Option A: Deploy via Dashboard (Recommended)

1. **Go to Render Dashboard**
   - Visit: https://dashboard.render.com/
   - Sign up/Login with GitHub

2. **Create New Web Service**
   - Click "New +" → "Web Service"
   - Connect your GitHub repository: `Tejaswiniy19/Student_Adminstration`
   - Click "Connect"

3. **Configure Service**
   ```
   Name:           sams-backend
   Region:         Oregon (US West)
   Branch:         main
   Root Directory: backend
   Runtime:        Node
   Build Command:  npm install && npx prisma generate
   Start Command:  node src/server.js
   Instance Type:  Free
   ```

4. **Add Environment Variables**
   Click "Advanced" → "Add Environment Variable":
   
   ```
   NODE_ENV=production
   DATABASE_URL=postgresql://postgres:Ytejaswini%40064@db.cfupssvxtjtobygpfzna.supabase.co:5432/postgres
   JWT_SECRET=NW1EA8vP7priWgjADL5VgUXk7d/qKxqTi9EbH7rlS2c=
   FRONTEND_URL=https://frontend-seven-tan-30.vercel.app
   ```

5. **Create Web Service**
   - Click "Create Web Service"
   - Wait 3-5 minutes for deployment
   - Copy your backend URL (e.g., `https://sams-backend-xxxx.onrender.com`)

### Option B: Deploy via render.yaml (Automatic)

1. **Push render.yaml to GitHub** (already done)

2. **Go to Render Dashboard**
   - Visit: https://dashboard.render.com/
   - Click "New +" → "Blueprint"
   - Select repository: `Tejaswiniy19/Student_Adminstration`
   - Click "Connect"

3. **Configure Environment Variables**
   Render will detect `render.yaml` and prompt for:
   ```
   DATABASE_URL=postgresql://postgres:Ytejaswini%40064@db.cfupssvxtjtobygpfzna.supabase.co:5432/postgres
   JWT_SECRET=NW1EA8vP7priWgjADL5VgUXk7d/qKxqTi9EbH7rlS2c=
   FRONTEND_URL=https://frontend-seven-tan-30.vercel.app
   ```

4. **Apply Blueprint**
   - Click "Apply"
   - Wait for deployment to complete

---

## 📋 Step 2: Update Frontend with Render Backend URL

After Render deployment completes, you'll get a URL like:
`https://sams-backend-xxxx.onrender.com`

### Update Vercel Environment Variable

```bash
cd frontend

# Remove old backend URL
npx vercel env rm VITE_API_URL production

# Add new Render backend URL
echo "https://sams-backend-xxxx.onrender.com" | npx vercel env add VITE_API_URL production --yes

# Redeploy frontend
npx vercel --prod
```

---

## 📋 Step 3: Update Backend CORS

```bash
cd backend

# Update FRONTEND_URL on Render
# Go to: https://dashboard.render.com/
# Select your service → Environment
# Edit FRONTEND_URL to match your Vercel URL
# Click "Save Changes"
# Render will auto-redeploy
```

---

## ⚡ Quick Setup Script

After getting your Render backend URL, run:

```bash
# Set your Render backend URL
RENDER_BACKEND_URL="https://sams-backend-xxxx.onrender.com"

# Update frontend
cd frontend
npx vercel env rm VITE_API_URL production
echo "$RENDER_BACKEND_URL" | npx vercel env add VITE_API_URL production --yes
npx vercel --prod

# Done! Frontend now points to Render backend
```

---

## 🧪 Test Your Deployment

### 1. Test Backend on Render
```bash
curl https://sams-backend-xxxx.onrender.com/api/auth/login
```
Should return: Login page or 404 (not 500)

### 2. Test Frontend on Vercel
Visit: https://frontend-seven-tan-30.vercel.app/register

Try registering and logging in!

---

## 📊 Deployment URLs

### Backend (Render)
- **URL:** https://sams-backend-xxxx.onrender.com
- **Dashboard:** https://dashboard.render.com/
- **Logs:** Available in Render dashboard

### Frontend (Vercel)
- **URL:** https://frontend-seven-tan-30.vercel.app
- **Dashboard:** https://vercel.com/dammuvinay143-3867s-projects/frontend

### Database (Supabase)
- **Host:** db.cfupssvxtjtobygpfzna.supabase.co
- **Dashboard:** https://supabase.com/dashboard

---

## 🔧 Environment Variables Summary

### Render Backend
```env
NODE_ENV=production
DATABASE_URL=postgresql://postgres:Ytejaswini%40064@db.cfupssvxtjtobygpfzna.supabase.co:5432/postgres
JWT_SECRET=NW1EA8vP7priWgjADL5VgUXk7d/qKxqTi9EbH7rlS2c=
FRONTEND_URL=https://frontend-seven-tan-30.vercel.app
```

### Vercel Frontend
```env
VITE_API_URL=https://sams-backend-xxxx.onrender.com
```

---

## 💰 Cost Breakdown

### FREE Plan
- **Render Free Tier:** 750 hours/month (enough for 1 service)
- **Vercel Free Tier:** 100GB bandwidth/month
- **Supabase Free Tier:** 500MB database

**Total Cost:** $0/month 🎉

### Limitations
- Render free tier spins down after 15 min of inactivity
- First request after spin down takes ~30 seconds
- 512MB RAM, limited CPU

---

## 🚨 Important Notes

### Render Free Tier Behavior
- **Cold Starts:** Service sleeps after 15 minutes of inactivity
- **Wake Time:** First request takes 20-30 seconds to wake up
- **Solution:** Use UptimeRobot or Cron-job.org to ping every 10 minutes

### Keep Render Service Awake (Optional)
Use a free service to ping your backend every 10 minutes:

1. **UptimeRobot** (https://uptimerobot.com)
   - Add monitor: `https://sams-backend-xxxx.onrender.com/api/auth/login`
   - Interval: 10 minutes

2. **Cron-job.org** (https://cron-job.org)
   - Create job: `https://sams-backend-xxxx.onrender.com/api/auth/login`
   - Schedule: Every 10 minutes

---

## 🔄 Redeployment

### Render Backend
- **Auto:** Pushes to GitHub main branch trigger redeployment
- **Manual:** Click "Manual Deploy" in Render dashboard

### Vercel Frontend
```bash
cd frontend
npx vercel --prod
```

---

## 📚 Troubleshooting

### Backend returns 500 error
- Check Render logs in dashboard
- Verify DATABASE_URL is correct
- Ensure Prisma Client was generated during build

### Frontend can't reach backend
- Verify VITE_API_URL is set correctly
- Check CORS: FRONTEND_URL must match Vercel URL
- Check Render service is running (not sleeping)

### Database connection failed
- Test connection: `psql $DATABASE_URL`
- Check Supabase project is active
- Verify DATABASE_URL format

---

## ✅ Deployment Checklist

- [ ] Render service created and deployed
- [ ] Backend URL copied (https://sams-backend-xxxx.onrender.com)
- [ ] Render environment variables set:
  - [ ] DATABASE_URL
  - [ ] JWT_SECRET
  - [ ] NODE_ENV
  - [ ] FRONTEND_URL
- [ ] Frontend VITE_API_URL updated to Render URL
- [ ] Frontend redeployed to Vercel
- [ ] Backend CORS updated with Vercel URL
- [ ] Registration tested successfully
- [ ] Login tested successfully

---

## 🎉 Success!

Once complete, you'll have:
- ✅ Backend running on Render
- ✅ Frontend running on Vercel
- ✅ Database on Supabase
- ✅ All connected and working
- ✅ $0/month cost

**Share your app:** https://frontend-seven-tan-30.vercel.app/register
