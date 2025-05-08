#!/bin/bash

set -e  # Exit on any error
LOG_FILE="/var/www/react-node78199/deploy.log"
APP_DIR=/var/www/react-node78199
FRONTEND_DIR=$APP_DIR/frontend
BACKEND_DIR=$APP_DIR/backend

echo "Starting deployment..." | tee -a $LOG_FILE

cd $APP_DIR

echo "Pulling latest changes..." | tee -a $LOG_FILE
if ! git pull origin main >> $LOG_FILE 2>&1; then
    echo "Git pull failed" | tee -a $LOG_FILE
    exit 1
fi

# Frontend build
cd $FRONTEND_DIR
echo "Installing frontend dependencies..." | tee -a $LOG_FILE
npm install >> $LOG_FILE 2>&1

echo "Building frontend..." | tee -a $LOG_FILE
npm run build >> $LOG_FILE 2>&1

echo "Copying frontend build..." | tee -a $LOG_FILE
mkdir -p /var/www/react-node78199/frontend/build/
cp -R build/* /var/www/react-node78199/frontend/build/

# Backend setup
cd $BACKEND_DIR
echo "Installing backend dependencies..." | tee -a $LOG_FILE
npm install >> $LOG_FILE 2>&1

echo "Restarting backend service..." | tee -a $LOG_FILE
pm2 delete all || true
pm2 start index.js --name backend-app >> $LOG_FILE 2>&1

echo "Deployment completed successfully" | tee -a $LOG_FILE
