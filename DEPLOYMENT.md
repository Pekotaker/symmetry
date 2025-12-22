# Deployment Guide - Symmetry

This guide walks you through deploying Symmetry to **Render** with **Supabase** (PostgreSQL), **Cloudinary** (images), and **Mailtrap** (email).

## Prerequisites

1. A GitHub repository with your code
2. Accounts on:
   - [Render](https://render.com)
   - [Supabase](https://supabase.com)
   - [Cloudinary](https://cloudinary.com)
   - [Mailtrap](https://mailtrap.io)

---

## Step 1: Set Up Supabase (PostgreSQL Database)

1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Create a new project
3. Note your **project reference** (in the URL: `https://supabase.com/dashboard/project/YOUR_PROJECT_REF`)
4. Go to **Settings > Database > Connection string > URI**
5. Copy the connection string (it looks like):
   ```
   postgresql://postgres:[YOUR-PASSWORD]@db.[YOUR-PROJECT-REF].supabase.co:5432/postgres
   ```
6. Replace `[YOUR-PASSWORD]` with your database password

---

## Step 2: Set Up Cloudinary (Image Storage)

1. Go to [Cloudinary Console](https://cloudinary.com/console)
2. Sign up or log in
3. From the Dashboard, find your **Account Details**:
   - Cloud Name
   - API Key
   - API Secret
4. Your `CLOUDINARY_URL` format is:
   ```
   cloudinary://API_KEY:API_SECRET@CLOUD_NAME
   ```

---

## Step 3: Set Up Mailtrap (Email)

1. Go to [Mailtrap Dashboard](https://mailtrap.io)
2. Navigate to **Email Sending > Sending Domains**
3. Add and verify your domain (or use their sandbox for testing)
4. Go to **SMTP Settings** and note:
   - Host: `live.smtp.mailtrap.io`
   - Port: `587`
   - Username: `api`
   - Password: (your API token)

---

## Step 4: Set Up Redis (for Sidekiq)

### Option A: Render Redis (Paid)
Create a Redis instance in Render Dashboard.

### Option B: Upstash Redis (Free Tier)
1. Go to [Upstash](https://upstash.com)
2. Create a Redis database
3. Copy the `REDIS_URL` from the dashboard

---

## Step 5: Deploy to Render

### Option A: Using render.yaml (Blueprint)

1. Push your code to GitHub
2. In Render Dashboard, click **New > Blueprint**
3. Connect your GitHub repository
4. Render will detect `render.yaml` and create services

### Option B: Manual Setup

#### Web Service
1. **New > Web Service**
2. Connect your GitHub repo
3. Settings:
   - **Name**: `symmetry`
   - **Runtime**: Ruby
   - **Build Command**: 
     ```bash
     bundle install && bundle exec rails assets:precompile && bundle exec rails db:migrate
     ```
   - **Start Command**: 
     ```bash
     bundle exec puma -C config/puma.rb
     ```

#### Background Worker (Sidekiq)
1. **New > Background Worker**
2. Connect same repo
3. Settings:
   - **Name**: `symmetry-worker`
   - **Runtime**: Ruby
   - **Build Command**: `bundle install`
   - **Start Command**: `bundle exec sidekiq -C config/sidekiq.yml`

---

## Step 6: Configure Environment Variables

In Render Dashboard, set these environment variables for **both** the web service and worker:

### Required Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `RAILS_ENV` | Rails environment | `production` |
| `RAILS_MASTER_KEY` | Your Rails master key (from `config/master.key`) | `abc123...` |
| `DATABASE_URL` | Supabase PostgreSQL URL | `postgresql://postgres:xxx@db.xxx.supabase.co:5432/postgres` |
| `REDIS_URL` | Redis connection URL | `redis://default:xxx@xxx.upstash.io:6379` |
| `APP_HOST` | Your Render app domain | `symmetry.onrender.com` |
| `CLOUDINARY_URL` | Cloudinary credentials | `cloudinary://xxx:xxx@cloud-name` |
| `SMTP_ADDRESS` | Mailtrap SMTP host | `live.smtp.mailtrap.io` |
| `SMTP_PORT` | SMTP port | `587` |
| `SMTP_DOMAIN` | Your app domain | `symmetry.onrender.com` |
| `SMTP_USERNAME` | Mailtrap username | `api` |
| `SMTP_PASSWORD` | Mailtrap API token | `your-token` |

### Optional Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `RAILS_LOG_TO_STDOUT` | Log to stdout | `true` |
| `RAILS_SERVE_STATIC_FILES` | Serve static files | `true` |
| `WEB_CONCURRENCY` | Puma workers | `2` |
| `RAILS_MAX_THREADS` | Puma threads | `5` |

---

## Step 7: Get Your Rails Master Key

If you don't have your master key:

```bash
# Check if you have config/master.key
cat config/master.key

# If not, you may need to regenerate credentials
EDITOR="code --wait" rails credentials:edit
```

**Important**: Never commit `config/master.key` to git!

---

## Step 8: Deploy!

1. After setting all environment variables, trigger a manual deploy in Render
2. Watch the logs for any errors
3. Once deployed, run database migrations (should happen automatically via build command)

---

## Troubleshooting

### "Cannot load credentials" error
- Make sure `RAILS_MASTER_KEY` is set correctly

### Database connection errors
- Verify your `DATABASE_URL` is correct
- Check Supabase allows connections from Render's IP addresses

### Images not uploading
- Verify `CLOUDINARY_URL` format is correct
- Check Cloudinary dashboard for upload logs

### Emails not sending
- Verify Mailtrap domain is verified
- Check Mailtrap logs for delivery status

### Sidekiq not processing jobs
- Ensure `REDIS_URL` is the same for web and worker services
- Check worker service logs in Render

---

## Local Development

For local development, create a `.env` file:

```bash
# .env (do not commit!)
REDIS_URL=redis://localhost:6379/0
```

Run the app locally:
```bash
bin/dev
```

