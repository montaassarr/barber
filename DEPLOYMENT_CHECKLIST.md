# 🚀 Quick Start Deployment Checklist

> **Complete in order. Est. time: 2-3 hours**

---

## Phase 1: Account Creation (30 minutes)

- [ ] **MongoDB Atlas**
  - [ ] Go to https://www.mongodb.com/cloud/atlas
  - [ ] Sign up with email
  - [ ] Verify email
  - [ ] Create free M0 cluster
  - [ ] Create database user: `barbershop_user`
  - [ ] Whitelist IP: `0.0.0.0/0` (for dev)
  - [ ] Copy connection string
  - [ ] Test locally: `mongosh "YOUR_URI"`

- [ ] **Runway**
  - [ ] Go to https://www.runwayapp.com
  - [ ] Sign up (GitHub auth recommended)
  - [ ] Create service: "barber-backend"
  - [ ] Copy Service ID (e.g., `srv_xxxxx`)
  - [ ] Generate API token
  - [ ] Copy API token

- [ ] **Vercel**
  - [ ] Go to https://vercel.com
  - [ ] Sign up with GitHub
  - [ ] Select your repository
  - [ ] Deploy (can skip for now, we'll use CLI)
  - [ ] Generate API token: https://vercel.com/account/tokens
  - [ ] Copy token

---

## Phase 2: Generate Secrets (10 minutes)

Run on your local machine:

```bash
# 1. JWT Secret (64-char hex)
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
# Copy output → save for step 3

# 2. Test MongoDB connection
mongosh "mongodb+srv://barbershop_user:PASSWORD@cluster.mongodb.net/reservi"
# Type: exit
# If works → MongoDB is ready
```

---

## Phase 3: Configure GitHub Secrets (30 minutes)

Go to: **Your GitHub Repo → Settings → Secrets and variables → Actions**

Click "New repository secret" for each:

```
✅ Step 1: Credentials
├─ Name: JWT_SECRET
│  Value: (paste from step 2 above - 64 char hex)
│  
├─ Name: MONGODB_URI
│  Value: mongodb+srv://barbershop_user:PASSWORD@cluster.mongodb.net/reservi?retryWrites=true&w=majority
│  
├─ Name: RUNWAY_API_TOKEN
│  Value: (from Runway account settings)
│  
├─ Name: RUNWAY_SERVICE_ID
│  Value: (from Runway service settings - e.g., srv_xxxxx)
│  
├─ Name: VERCEL_TOKEN
│  Value: (from Vercel settings → tokens)
│  
└─ Name: VERCEL_PROJECT_URL
   Value: your-project.vercel.app (from Vercel domain)

✅ Step 2: Frontend Config
├─ Name: VITE_API_BASE_URL_DOCKER
│  Value: (will set after first deploy - for now use localhost)
│  Value: http://localhost:4000
│  
└─ Name: VITE_VAPID_PUBLIC_KEY
   Value: BK18bQ4NEXiaZlIV6brVvYpJb4r1JOGyUybne_94kbk49m2b6w-RW1u1mLW-Ib8oBCJFprdw1BL8x7-olQi8WwA

✅ Step 3: Backend Config
├─ Name: CORS_ORIGIN
│  Value: http://localhost:3000 (will update after Vercel deploy)
│  
├─ Name: JWT_EXPIRES_IN
│  Value: 7d
│  
└─ Name: (Skip until after first deploy)

✅ Step 4: Seed Data
├─ Name: SEED_ADMIN_EMAIL
│  Value: owner@barbershop.com (change if desired)
│  
├─ Name: SEED_ADMIN_PASSWORD
│  Value: ChangeMe123! (⚠️ CHANGE THIS!)
│  
├─ Name: SEED_SALON_NAME
│  Value: Demo Salon
│  
├─ Name: SEED_SALON_SLUG
│  Value: demo-salon
│  
├─ Name: SEED_SUPER_ADMIN_EMAIL
│  Value: superadmin@barbershop.com
│  
└─ Name: SEED_SUPER_ADMIN_PASSWORD
   Value: ChangeMe123! (⚠️ CHANGE THIS!)

✅ Step 5: Optional
└─ Name: SLACK_WEBHOOK
   Value: (if you have Slack workspace, create incoming webhook)
   Otherwise: Skip
```

---

## Phase 4: First Deployment (45 minutes)

### 4.1: Push to GitHub

```bash
cd /home/montassar/Desktop/reservi

# Verify all files are ready
git status

# Add all changes
git add -A

# Commit
git commit -m "feat: add production CI/CD pipeline with 3-stage deployment"

# Push to main branch
git push origin main
```

### 4.2: Monitor GitHub Actions

1. Go to **Your Repo → Actions**
2. Click the latest workflow run
3. Watch the stages:

```
STAGE 1: TEST ✅
├─ Checkout code
├─ Setup Node.js 20
├─ Install dependencies
├─ TypeScript compilation
└─ Run unit tests

STAGE 2: BUILD ✅
├─ Setup Docker Buildx
├─ Login to GHCR
├─ Build backend image
├─ Push backend image
├─ Build frontend image
└─ Push frontend image

STAGE 3: DEPLOY ❌ (Expected to fail - need RUNWAY_API_URL first)
├─ Deploy backend to Runway
│  └─ Will succeed, get URL
├─ Deploy frontend to Vercel
│  └─ May fail (missing RUNWAY_API_URL)
└─ Integration tests
   └─ May fail (services not ready)
```

### 4.3: Get Runway API URL

After backend deploys (even if frontend fails):

1. Go to **Runway Dashboard → Service → Deployments**
2. Click latest deployment
3. Copy URL from details: `https://srv_xxxxx.runway.app`

### 4.4: Update GitHub Secrets

1. Go to **Settings → Secrets**
2. Update these secrets:

```
1. RUNWAY_API_URL
   Value: https://srv_xxxxx.runway.app

2. VITE_API_BASE_URL_DOCKER
   Value: https://srv_xxxxx.runway.app

3. CORS_ORIGIN
   Value: https://your-vercel-domain.vercel.app
```

### 4.5: Get Vercel Domain

1. Go to **Vercel Dashboard → Project → Domains**
2. Copy domain (should be auto-generated)
3. Format: `your-project-name.vercel.app`

### 4.6: Second Deployment (Re-trigger)

```bash
# Make a small change to trigger workflow again
echo "" >> README.md
git add README.md
git commit -m "trigger: redeploy with updated secrets"
git push origin main
```

Or manually re-run:
1. GitHub → Actions → Latest workflow
2. Click "Re-run all jobs"

This time everything should deploy successfully!

---

## Phase 5: Verification (15 minutes)

### 5.1: Test Backend Health

```bash
# Replace with your actual Runway URL
curl -i https://srv_xxxxx.runway.app/health

# Expected response:
# HTTP/1.1 200 OK
# {"status":"ok"}
```

### 5.2: Test Frontend Accessibility

```bash
# Replace with your Vercel domain
curl -i https://your-app.vercel.app

# Expected response:
# HTTP/1.1 200 OK
# <html>
#   <head>
#     <title>Reservi Barbershop</title>
```

### 5.3: Test User Login (In Browser)

1. Open https://your-app.vercel.app
2. Go to login page
3. Enter credentials:
   - Email: `owner@barbershop.com` (or your seed email)
   - Password: `ChangeMe123!` (or your seed password)
4. Click Login
5. Should see: Dashboard loads successfully

### 5.4: Check Network Tab (In Browser)

1. Open DevTools (F12)
2. Go to Network tab
3. Reload page
4. Check API requests:
   - Should start with: `https://srv_xxxxx.runway.app`
   - Should NOT be `http://localhost:4000`
5. All requests should be HTTP 200

### 5.5: Verify Database Connection

Login should create a session in MongoDB:

```bash
mongosh "mongodb+srv://barbershop_user:PASSWORD@cluster.mongodb.net/reservi"

# In mongo shell:
use reservi
db.users.find().pretty()
# Should see your admin user
```

---

## Phase 6: Production Hardening (Optional)

### 6.1: Update Passwords

```bash
# SSH into production / update via Runway dashboard
Change:
├─ SEED_ADMIN_PASSWORD → Strong password (16+ chars, symbols)
├─ SEED_SUPER_ADMIN_PASSWORD → Strong password
└─ MongoDB Atlas password → Change via Atlas dashboard
```

### 6.2: Update IP Whitelist

MongoDB Atlas → Network Access:
```
Before (Development):
├─ IP: 0.0.0.0/0 (allow all)

After (Production):
├─ Get Runway's IP address
├─ Change to specific IP only
└─ Removes 0.0.0.0/0
```

### 6.3: Enable Monitoring

Runway Dashboard:
- [ ] Setup monitoring alerts
- [ ] Configure log aggregation
- [ ] Enable auto-scaling (if available)

Vercel Dashboard:
- [ ] Setup speed insights
- [ ] Configure performance monitoring
- [ ] Setup deployment protection on main branch

---

## Phase 7: Future Deployments (Ongoing)

After initial setup, subsequent deployments are automatic:

```bash
# 1. Make code changes
git add -A
git commit -m "feat: add new feature"

# 2. Push to main
git push origin main

# 3. GitHub Actions automatically:
#    ✅ Runs tests
#    ✅ Builds Docker images
#    ✅ Deploys to Runway
#    ✅ Deploys to Vercel
#    ✅ Runs integration tests

# 4. Monitor at: GitHub → Actions
```

**Deployment time:** ~10-15 minutes (with caching)

---

## Troubleshooting

### "Deploy failed - GitHub token not valid"
- [ ] Check secrets are spelled correctly (case-sensitive)
- [ ] Verify secrets are under repo, not organization
- [ ] Check GitHub token hasn't expired

### "Runway deployment failed"
- [ ] Verify RUNWAY_API_TOKEN is correct
- [ ] Verify RUNWAY_SERVICE_ID is correct
- [ ] Check Runway dashboard for error details

### "Frontend CORS error"
- [ ] Verify CORS_ORIGIN matches Vercel domain exactly
- [ ] No trailing slash: ❌ `https://app.com/` → ✅ `https://app.com`
- [ ] Re-deploy backend after updating

### "Can't connect to MongoDB"
- [ ] Test locally: `mongosh "YOUR_URI"`
- [ ] Verify IP whitelist includes your address
- [ ] Check MongoDB password doesn't have special chars (URL encode if needed)

### "Tests failing"
- [ ] Run locally: `cd barber-backend-node && npm run build && npm run test`
- [ ] Fix errors in code
- [ ] Push again

---

## Success Criteria Checklist

- [ ] GitHub Actions workflow runs on each push
- [ ] Tests pass (green checkmark)
- [ ] Docker images built (green checkmark)
- [ ] Backend deployed to Runway (green checkmark)
- [ ] Frontend deployed to Vercel (green checkmark)
- [ ] Can curl backend health endpoint → 200 OK
- [ ] Can open frontend in browser → loads successfully
- [ ] Can login with seed credentials
- [ ] API calls go to Runway URL (not localhost)
- [ ] Database contains created session/user

---

## Important URLs

```
GitHub Actions Dashboard:
https://github.com/montaassarr/barber/actions

MongoDB Atlas:
https://cloud.mongodb.com

Runway Dashboard:
https://www.runwayapp.com/dashboard

Vercel Dashboard:
https://vercel.com/dashboard

Frontend URL (after deploy):
https://your-project.vercel.app

Backend URL (after deploy):
https://srv_xxxxx.runway.app

Backend Health Check:
https://srv_xxxxx.runway.app/health
```

---

## Next Steps After Verification

1. ✅ Deployment working? → Go to full docs
2. ✅ Users happy? → Setup monitoring
3. ✅ Need custom domain? → Configure in Vercel & Runway
4. ✅ Want auto-scaling? → Configure in Runway
5. ✅ Need analytics? → Setup Vercel Analytics + Runway monitoring

---

**Questions?** See `PRODUCTION_DEPLOYMENT_GUIDE.md` for detailed documentation.

**Good luck! 🚀**
