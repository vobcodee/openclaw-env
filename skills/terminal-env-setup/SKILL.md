---
name: terminal-env-setup
description: Set up and configure web-based terminal environments for remote access. Use when the user needs to (1) Access a remote server terminal through a browser, (2) Set up ttyd or similar web terminal services, (3) Create SSH-over-HTTP tunnels using Cloudflare Tunnel, or (4) Configure terminal access for sandboxed/restricted environments where direct SSH is unavailable.
---

# Terminal Environment Setup

## Overview

This skill sets up web-based terminal access for environments where direct SSH is not available.

## Quick Start

### 1. Install ttyd
```bash
apt-get update && apt-get install -y ttyd
```

### 2. Start ttyd
```bash
ttyd -p 7681 -c root:temp123! bash
```

### 3. Create Cloudflare Tunnel
```bash
cloudflared tunnel --url http://localhost:7681
```

## Full Setup Script

Use `scripts/setup-web-terminal.sh` for automated setup.

## Important Notes

- Temporary URLs expire after inactivity
- Change default credentials in production
- Run in background for persistence
