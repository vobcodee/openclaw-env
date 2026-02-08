#!/bin/bash
PORT=${1:-7681}
USER=${2:-root}
PASSWORD=${3:-temp123!}

echo "=== Web Terminal Setup ==="

if ! command -v ttyd &> /dev/null; then
    apt-get update > /dev/null 2>&1
    apt-get install -y ttyd > /dev/null 2>&1
fi

pkill ttyd 2> /dev/null
pkill cloudflared 2> /dev/null
sleep 1

nohup ttyd -p "$PORT" -c "$USER:$PASSWORD" bash > /tmp/ttyd.log 2>&1 &
echo "ttyd started"
sleep 2

nohup cloudflared tunnel --url "http://localhost:$PORT" > /tmp/tunnel.log 2>&1 &
echo "Tunnel starting..."
echo "Check /tmp/tunnel.log for URL"
