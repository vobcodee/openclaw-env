#!/bin/bash
# Devbox Coding Environment Setup Script

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
PROJECT_NAME=${1:-"my-project"}
GITHUB_USERNAME=${2:-""}
GITHUB_TOKEN=${3:-""}
PORT=${4:-3001}

echo -e "${GREEN}Setting up Devbox Coding Environment...${NC}"
echo "Project: $PROJECT_NAME"
echo "Port: $PORT"

# Check prerequisites
if ! command -v pnpm &> /dev/null; then
    echo -e "${RED}pnpm not found. Installing...${NC}"
    npm install -g pnpm
fi

if ! command -v git &> /dev/null; then
    echo -e "${RED}git not found. Please install git.${NC}"
    exit 1
fi

# Create project
echo -e "${YELLOW}Creating Next.js project...${NC}"
cd /root
if [ -d "$PROJECT_NAME" ]; then
    echo -e "${YELLOW}Directory exists. Using existing project.${NC}"
else
    pnpm create next-app@latest "$PROJECT_NAME" \
        --typescript --tailwind --eslint --app \
        --src-dir --import-alias "@/*" --use-pnpm
fi

cd "/root/$PROJECT_NAME"

# Git setup
echo -e "${YELLOW}Setting up Git...${NC}"
if [ ! -d ".git" ]; then
    git init
    git config user.email "dev@example.com"
    git config user.name "Developer"
fi

# GitHub setup (if credentials provided)
if [ -n "$GITHUB_USERNAME" ] && [ -n "$GITHUB_TOKEN" ]; then
    echo -e "${YELLOW}Configuring GitHub...${NC}"
    
    # Check if repo exists
    if ! git remote get-url origin &> /dev/null; then
        # Create repo using gh CLI if available
        if command -v gh &> /dev/null; then
            echo "$GITHUB_TOKEN" | gh auth login --with-token 2>/dev/null || true
            gh repo create "$PROJECT_NAME" --public --source=. --push || true
        else
            echo -e "${YELLOW}GitHub CLI not found. Please create repo manually.${NC}"
            echo "Then run: git remote add origin https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/$PROJECT_NAME.git"
        fi
    fi
    
    # Commit and push
    git add . 2>/dev/null || true
    git commit -m "Initial commit" 2>/dev/null || true
    git push -u origin main 2>/dev/null || echo -e "${YELLOW}Push failed. Check remote URL.${NC}"
fi

# Build
echo -e "${YELLOW}Building project...${NC}"
pnpm build

# Start server
echo -e "${GREEN}Starting server on port $PORT...${NC}"
echo -e "${GREEN}To create public tunnel, run in another session:${NC}"
echo -e "  cloudflared tunnel --url http://localhost:$PORT"

pnpm start --hostname 0.0.0.0 --port "$PORT"
