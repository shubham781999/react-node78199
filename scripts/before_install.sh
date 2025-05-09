#!/bin/bash

# Stop existing Node.js server if running
pm2 stop all || true

# Remove old frontend build and backend files
rm -rf /var/www/html/*
rm -rf /app/backend/*

# Create required directories if not present
mkdir -p /var/www/html
mkdir -p /app/backend
