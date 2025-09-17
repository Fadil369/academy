#!/bin/bash

# Deployment script for Academy project
# This script pulls the latest changes from the repository

echo "Starting deployment..."

# Navigate to the project directory
cd /home/ubuntu/projects/academy

# Pull the latest changes
echo "Pulling latest changes..."
git pull origin main

# Install/update dependencies (if needed)
# npm install  # Uncomment if using Node.js
# pip install -r requirements.txt  # Uncomment if using Python

echo "Deployment completed successfully!"