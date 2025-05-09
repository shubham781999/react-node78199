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
echo "Cleaning frontend dependencies..." | tee -a $LOG_FILE
rm -rf node_modules package-lock.json >> $LOG_FILE 2>&1

echo "Installing frontend dependencies..." | tee -a $LOG_FILE
if ! npm install >> $LOG_FILE 2>&1; then
    echo "Frontend npm install failed" | tee -a $LOG_FILE
    exit 1
fi

echo "Building frontend..." | tee -a $LOG_FILE
if ! npm run build >> $LOG_FILE 2>&1; then
    echo "Frontend build failed" | tee -a $LOG_FILE
    exit 1
fi

echo "Copying frontend build..." | tee -a $LOG_FILE
mkdir -p /var/www/react-node78199/frontend/build/
cp -R build/* /var/www/react-node78199/frontend/build/

# Backend setup
cd $BACKEND_DIR
echo "Installing backend dependencies..." | tee -a $LOG_FILE
if ! npm install >> $LOG_FILE 2>&1; then
    echo "Backend npm install failed" | tee -a $LOG_FILE
    exit 1
fi

echo "Restarting backend service..." | tee -a $LOG_FILE
pm2 delete all || true
pm2 start index.js --name backend-app >> $LOG_FILE 2>&1

echo "Deployment completed successfully" | tee -a $LOG_FILE
