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
truncate "logs/ci.log" --backup 2>/dev/null || true
touchup "bin/" "artifacts/" "logs/"

# Stage 5: Build (with timeout)
out "Stage 5: Build"
out "Building project..." 4
# Note: For continuous disk monitoring during build, run in separate terminal:
# monitor disk / --warn 85% --then out "Disk space low during build!" 3

# Build with timeout
timer 10m crystal build src/main.cr -o bin/app || {
  out "Build failed or timed out" 2
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
BUILD_NUMBER=$(randomize 1000 9999)
echo "BUILD_NUMBER=$BUILD_NUMBER" >> artifacts/build_info.txt
out "Checksum: $(cat artifacts/checksum.txt)" 4
out "Build number: $BUILD_NUMBER" 4

# Stage 9: Dump build info
out "Stage 9: Build information"
dump --system
dump --env CI BUILD_NUMBER

out "CI pipeline completed successfully!" 1

