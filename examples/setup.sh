#!/bin/bash
# Example: Project setup script
# Demonstrates interactive prompts, environment setup, and file creation

set -e

out "Setting up project..."

# Ask for project name
PROJECT_NAME=$(ask "Enter project name:" --default "myproject")
out "Project name: $PROJECT_NAME"

# Ask for environment
ENV_TYPE=$(ask "Environment (dev/staging/prod):" --default "dev")
out "Environment: $ENV_TYPE"

# Check if setup should continue
confirm "Setup project '$PROJECT_NAME' in '$ENV_TYPE' environment?" || {
  out "Setup cancelled" 3
  exit 0
}

# Create project structure
out "Creating project structure..."
touchup "$PROJECT_NAME/src/" "$PROJECT_NAME/lib/" "$PROJECT_NAME/config/" "$PROJECT_NAME/logs/"

# Create config file
CONFIG_FILE="$PROJECT_NAME/config/$ENV_TYPE.json"
touchup "$CONFIG_FILE"
cat > "$CONFIG_FILE" <<EOF
{
  "name": "$PROJECT_NAME",
  "environment": "$ENV_TYPE",
  "version": "1.0.0"
}
EOF

# Set environment variables
envset set PROJECT_NAME "$PROJECT_NAME"
envset set ENV_TYPE "$ENV_TYPE"

# Verify setup
manifest "$PROJECT_NAME/src/" "$PROJECT_NAME/lib/" "$CONFIG_FILE" || {
  out "Setup verification failed" 2
  exit 1
}

out "Project setup complete!" 1
dump --config "$CONFIG_FILE"

