#!/bin/bash

# Exit on error
set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print status messages
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

# Function to print error messages
print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Heroku CLI is installed
if ! command -v heroku &> /dev/null; then
    print_error "Heroku CLI is not installed. Please install it first:"
    print_error "https://devcenter.heroku.com/articles/heroku-cli"
    exit 1
fi

# Check if user is logged into Heroku
if ! heroku auth:whoami &> /dev/null; then
    print_error "Not logged into Heroku. Please run 'heroku login' first"
    exit 1
fi

# Get Heroku app name from environment or prompt
HEROKU_APP_NAME=${HEROKU_APP_NAME:-""}
if [ -z "$HEROKU_APP_NAME" ]; then
    # Try to get app name from git remote
    HEROKU_APP_NAME=$(git remote -v | grep heroku | head -n 1 | sed 's/.*heroku.com:\(.*\)\.git.*/\1/')
    
    if [ -z "$HEROKU_APP_NAME" ]; then
        print_error "HEROKU_APP_NAME not set. Please either:"
        print_error "1. Set HEROKU_APP_NAME environment variable"
        print_error "2. Add Heroku as a git remote: heroku git:remote -a your-app-name"
        exit 1
    fi
fi

print_status "Using Heroku app: $HEROKU_APP_NAME"

# Backup remote database
print_status "Creating backup of remote database..."
heroku pg:backups:capture --app $HEROKU_APP_NAME

# Run seeds on Heroku
print_status "Running seeds on Heroku..."
heroku run rails db:seed --app $HEROKU_APP_NAME

print_status "Seed sync completed successfully!" 