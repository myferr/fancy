#!/bin/bash
# Example: Development workflow script
# Demonstrates watch, confirm, out, and interactive development

set -e

out "Development workflow helper"

# Check development environment
out "Checking development environment..."
check --binary git --binary crystal --env HOME || {
  out "Development environment not ready" 2
  exit 1
}

# Ask what to do
ACTION=$(ask "What would you like to do? (watch/test/build/clean):" --default "watch")

case "$ACTION" in
  watch)
    out "Starting file watcher..."
    out "Watching src/ for changes..." 4
    watch src/ 'out "File changed, rebuilding..." 3 && crystal build src/main.cr -o bin/app'
    ;;
  test)
    out "Running tests..."
    out "Running test suite..." 4
    # crystal spec
    out "Tests passed!" 1
    ;;
  build)
    out "Building project..."
    clean "bin/" "*.dwarf"
    touchup "bin/"
    crystal build src/main.cr -o bin/app || {
      out "Build failed" 2
      exit 1
    }
    out "Build successful!" 1
    ;;
  clean)
    out "Cleaning project..."
    confirm "Clean all build artifacts?" || {
      out "Clean cancelled" 3
      exit 0
    }
    clean "bin/" "*.dwarf" "*.o" ".crystal/"
    out "Clean complete!" 1
    ;;
  *)
    out "Unknown action: $ACTION" 2
    exit 1
    ;;
esac

