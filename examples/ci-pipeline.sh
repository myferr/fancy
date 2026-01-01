#!/bin/bash
# Example: CI/CD pipeline script
# Demonstrates comprehensive checks, validation, and conditional execution

set -e

out "Running CI pipeline..."

# Stage 1: Environment validation
out "Stage 1: Environment validation"
check --binary git --binary crystal --env CI --env BUILD_NUMBER || {
  out "Environment validation failed" 2
  exit 1
}

# Stage 2: Project structure validation
out "Stage 2: Project structure validation"
guard structure . src/ lib/ spec/ || {
  out "Project structure invalid" 2
  exit 1
}

# Stage 3: Verify required files
out "Stage 3: File manifest check"
manifest src/main.cr lib/ spec/ README.md || {
  out "Required files missing" 2
  exit 1
}

# Stage 4: Clean and prepare
out "Stage 4: Clean workspace"
clean "bin/" "*.dwarf" "*.o"
touchup "bin/" "artifacts/"

# Stage 5: Build
out "Stage 5: Build"
out "Building project..." 4
crystal build src/main.cr -o bin/app || {
  out "Build failed" 2
  exit 1
}

# Stage 6: Verify build output
manifest bin/app || {
  out "Build output missing" 2
  exit 1
}

# Stage 7: Run tests (if spec directory exists)
eq EXPR "[ -d 'spec' ]" THEN out "Running tests..." 4
eq EXPR "[ -d 'spec' ]" THEN crystal spec || {
  out "Tests failed" 2
  exit 1
}

# Stage 8: Compute checksums
out "Stage 8: Computing checksums"
hashit --algorithm sha256 bin/app > artifacts/checksum.txt
out "Checksum: $(cat artifacts/checksum.txt)" 4

# Stage 9: Dump build info
out "Stage 9: Build information"
dump --system
dump --env CI BUILD_NUMBER

out "CI pipeline completed successfully!" 1

