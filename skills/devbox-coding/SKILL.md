# Devbox Coding Environment Setup

Setup a complete coding project environment with GitHub sync and Cloudflare Tunnel deployment.

## Overview

This skill sets up:
- Next.js project with TypeScript + Tailwind
- GitHub repository integration
- Cloudflare Tunnel for public access
- Google Drive backup (optional)

## Prerequisites

- GitHub account
- Personal Access Token with `repo` scope
- Cloudflare (free tunnel works)

## Quick Start

### 1. Create Project

```bash
# Set project name
PROJECT_NAME="my-project"

# Create Next.js app
cd /root
pnpm create next-app@latest $PROJECT_NAME \
  --typescript --tailwind --eslint --app \
  --src-dir --import-alias "@/*" --use-pnpm
```

### 2. GitHub Setup

```bash
cd /root/$PROJECT_NAME

# Initialize git
git init
git config user.email "dev@example.com"
git config user.name "Developer"

# Add remote (replace TOKEN and USERNAME)
git remote add origin https://USERNAME:TOKEN@github.com/USERNAME/REPO.git

# Commit and push
git add .
git commit -m "Initial commit"
git push -u origin main
```

### 3. Build & Deploy

```bash
# Build
cd /root/$PROJECT_NAME
pnpm build

# Start server
pnpm start --hostname 0.0.0.0 --port 3001

# In another session, start tunnel
cloudflared tunnel --url http://localhost:3001
```

## File Structure

```
/root/
├── my-project/          # Local development
│   ├── src/app/         # Source code
│   ├── public/          # Static files
│   └── .next/           # Build output
├── .config/gh/          # GitHub CLI config
└── .config/rclone/      # Rclone config (if using GDrive)
```

## Environment Variables

| Variable | Description |
|----------|-------------|
| `GITHUB_TOKEN` | GitHub Personal Access Token |
| `GITHUB_USERNAME` | GitHub username |
| `PROJECT_NAME` | Project name |

## Commands Reference

| Command | Description |
|---------|-------------|
| `pnpm dev` | Development server |
| `pnpm build` | Production build |
| `pnpm start` | Production server |
| `git push` | Push to GitHub |
| `cloudflared tunnel --url http://localhost:3001` | Create public URL |

## Backup to Google Drive (Optional)

```bash
# Sync source code only (exclude node_modules)
rclone sync /root/$PROJECT_NAME/src gdrive:1/projects/$PROJECT_NAME/src
rclone sync /root/$PROJECT_NAME/public gdrive:1/projects/$PROJECT_NAME/public
```

## Troubleshooting

### Port already in use
```bash
# Use different port
pnpm start --hostname 0.0.0.0 --port 3002
cloudflared tunnel --url http://localhost:3002
```

### GitHub auth failed
- Check token has `repo` scope
- Verify username and repo name

### Tunnel not working
- Check server is running on correct port
- Restart tunnel if needed

## Notes

- Keep `node_modules` in local only (don't sync to GitHub/GDrive)
- Use `.gitignore` for sensitive files
- Tunnel URLs are temporary (change on restart)
- For permanent URL, use named Cloudflare Tunnel
