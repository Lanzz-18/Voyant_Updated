# Hosting Backend on Render using CLI - Complete Guide

## Step 1: Install Render CLI
Already done! You have Render CLI v0.3.2 installed.

To verify:
```bash
render --version
```

## Step 2: Authenticate with Render
1. First, authenticate with Render:
```bash
render login
```

2. This will open a browser window asking you to log in or sign up
3. After authentication, you'll get an API token

## Step 3: Create Service using CLI

Navigate to your project root:
```bash
cd C:\Users\user\OneDrive\Desktop\Voyant\Voyant
```

Create a new web service:
```bash
render create-web-service \
  --name voyant-backend \
  --repo https://github.com/ThinukaR/Voyant \
  --branch feature/render-deployment \
  --runtime node \
  --build-command "cd backend && npm install" \
  --start-command "cd backend && npm start" \
  --auto-deploy false
```

Or with environment variables:
```bash
render create-web-service \
  --name voyant-backend \
  --repo https://github.com/ThinukaR/Voyant \
  --branch feature/render-deployment \
  --runtime node \
  --build-command "cd backend && npm install" \
  --start-command "cd backend && npm start" \
  --env MONGO_URI=mongodb+srv://voyantAdmin:1VfeLDAFCQU84yJ7@voyant.y7zwi17.mongodb.net/voyant \
  --env PORT=3000 \
  --auto-deploy false
```

## Step 4: Deploy using CLI
```bash
render deploy --name voyant-backend
```

## Step 5: Check Deployment Status
```bash
render logs --name voyant-backend --follow
```

## Step 6: Get Your Service URL
```bash
render services --name voyant-backend
```

This will show you your Render service URL.

---

## Useful CLI Commands

### List all services:
```bash
render services
```

### View logs:
```bash
render logs --name voyant-backend --follow
```

### Get service details:
```bash
render services --name voyant-backend --json
```

### Update environment variables:
```bash
render env-vars set --name voyant-backend --key MONGO_URI --value "your-new-uri"
```

### Redeploy from specific commit:
```bash
render deploy --name voyant-backend --commit <commit-hash>
```

### Trigger manual deployment:
```bash
render deploy --name voyant-backend
```

### Delete service:
```bash
render delete --name voyant-backend
```

---

## Alternative: Using render.yaml with CLI

You already have a `render.yaml` file in your backend folder. You can also deploy using:

```bash
render blueprint deploy
```

This will use your `render.yaml` configuration automatically.

---

## Troubleshooting

### Authentication Issues:
```bash
render logout
render login
```

### View detailed logs:
```bash
render logs --name voyant-backend --follow --num-lines 100
```

### Check service health:
```bash
# Once deployed, test with curl
curl https://your-service-name.onrender.com/health
```

---

## Environment Variables Setup via CLI

Set up all required environment variables:
```bash
render env-vars set --name voyant-backend --key MONGO_URI --value "mongodb+srv://voyantAdmin:1VfeLDAFCQU84yJ7@voyant.y7zwi17.mongodb.net/voyant"
render env-vars set --name voyant-backend --key PORT --value "3000"
```

View all environment variables:
```bash
render env-vars list --name voyant-backend
```

---

## Quick Deployment Steps (Summary)

1. **Login:**
   ```bash
   render login
   ```

2. **Create service:**
   ```bash
   render create-web-service \
     --name voyant-backend \
     --repo https://github.com/ThinukaR/Voyant \
     --branch feature/render-deployment \
     --runtime node \
     --build-command "cd backend && npm install" \
     --start-command "cd backend && npm start"
   ```

3. **Set environment variables:**
   ```bash
   render env-vars set --name voyant-backend --key MONGO_URI --value "mongodb+srv://voyantAdmin:1VfeLDAFCQU84yJ7@voyant.y7zwi17.mongodb.net/voyant"
   render env-vars set --name voyant-backend --key PORT --value "3000"
   ```

4. **Deploy:**
   ```bash
   render deploy --name voyant-backend
   ```

5. **Check logs:**
   ```bash
   render logs --name voyant-backend --follow
   ```

6. **Get your URL:**
   ```bash
   render services --name voyant-backend
   ```

That's it! Your backend is now live on Render! 🚀

