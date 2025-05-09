#!/bin/bash

# Start the backend using PM2
cd /app/backend

# If .env file is present, load it
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

# Start server with PM2
pm2 start index.js --name "backend-app" --watch

# Restart Nginx to serve the frontend
systemctl restart nginx
