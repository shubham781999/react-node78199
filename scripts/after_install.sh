#!/bin/bash

# Navigate to backend
cd /app/backend

# Install backend dependencies
npm install

# Copy .env file if exists in S3 or other location (adjust path as needed)
if [ -f /app/backend/.env ]; then
  cp /app/backend/.env /app/backend/.env
fi

# Build frontend (if needed)
cd /var/www/html
