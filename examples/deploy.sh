#!/bin/bash
# Example: Deployment script using Fancy binaries
# This script demonstrates checking prerequisites, ensuring files exist, and deploying

set -e

out "Starting deployment process..."

# Preflight checks
out "Running preflight checks..."
check --binary git --env HOME --file package.json || {
  out "Preflight checks failed" 2
  exit 1
}

# Ensure required directories exist
out "Ensuring directories exist..."
touchup dist/ logs/ backups/

# Verify manifest of required files
out "Verifying project files..."
manifest package.json README.md src/ || {
  out "Required files missing" 2
  exit 1
}

# Check environment variables
envset check DEPLOY_ENV API_KEY || {
  out "Required environment variables not set" 2
  exit 1
}

# Check disk space before deployment (one-time check)
out "Checking disk space..." 4
# Note: For continuous monitoring, use: monitor disk / --warn 90% --then out "Disk space critical!" 2

# Ask for confirmation
confirm "Deploy to ${DEPLOY_ENV:-production}?" --no || {
  out "Deployment cancelled" 3
  exit 0
}

# Build step with timeout
out "Building project..." 4
timer 5m npm run build || {
  out "Build failed or timed out" 2
  exit 1
}

# Deploy
out "Deploying..." 4
# Your deployment command here
# rsync -av dist/ user@server:/app/

out "Deployment successful!" 1

