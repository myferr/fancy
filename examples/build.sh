#!/bin/bash
# Example: Build script with validation and cleanup
# Demonstrates guard, clean, manifest, and conditional execution

set -e

PROJECT_NAME="myapp"
BUILD_DIR="build"
DIST_DIR="dist"

out "Building $PROJECT_NAME..."

# Validate project structure
out "Validating project structure..."
guard structure . src/ lib/ config/ || {
  out "Invalid project structure" 2
  exit 1
}

# Check for required binaries
check --binary crystal --binary npm || {
  out "Required build tools missing" 2
  exit 1
}

# Clean previous builds
out "Cleaning previous builds..."
clean "$BUILD_DIR/" "$DIST_DIR/" "*.o" "*.dwarf"

# Truncate log files before build
out "Clearing old log files..."
truncate "$BUILD_DIR/build.log" --backup 2>/dev/null || true
truncate "$DIST_DIR/deploy.log" --backup 2>/dev/null || true

# Ensure build directories exist
touchup "$BUILD_DIR/" "$DIST_DIR/"

# Verify source files exist
manifest src/main.cr lib/utils.cr || {
  out "Source files missing" 2
  exit 1
}

# Build with conditional logic
eq EXPR "[ -f 'package.json' ]" THEN out "Installing npm dependencies..." 4
eq EXPR "[ -f 'package.json' ]" THEN npm install

# Build Crystal project
out "Compiling Crystal project..." 4
crystal build src/main.cr -o "$BUILD_DIR/$PROJECT_NAME" || {
  out "Compilation failed" 2
  exit 1
}

# Copy assets if they exist
copycat assets/ "$DIST_DIR/assets/" || true

# Verify build output
manifest "$BUILD_DIR/$PROJECT_NAME" || {
  out "Build output missing" 2
  exit 1
}

# Generate random build ID
BUILD_ID=$(randomize 1000 9999)
out "Build completed successfully! Build ID: $BUILD_ID" 1

