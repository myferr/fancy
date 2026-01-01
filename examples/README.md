# Fancy Examples

This directory contains example bash scripts demonstrating real-world usage of Fancy binaries.

## Examples

### `deploy.sh`
A deployment script that:
- Runs preflight checks (binaries, env vars, files)
- Ensures required directories exist
- Verifies project files with manifest
- Checks environment variables
- Uses interactive confirmation
- Provides status output

**Usage:**
```bash
./examples/deploy.sh
```

### `build.sh`
A build script that:
- Validates project structure
- Checks for required build tools
- Cleans previous builds
- Conditionally installs dependencies
- Builds and verifies output

**Usage:**
```bash
./examples/build.sh
```

### `setup.sh`
An interactive project setup script that:
- Prompts for project name and environment
- Creates project structure
- Generates configuration files
- Sets environment variables
- Verifies setup completion

**Usage:**
```bash
./examples/setup.sh
```

### `backup.sh`
A backup script with verification that:
- Creates timestamped backup directories
- Verifies source files exist
- Computes checksums for verification
- Copies files safely
- Verifies backup integrity

**Usage:**
```bash
./examples/backup.sh
```

### `dev-workflow.sh`
A development workflow helper that:
- Checks development environment
- Provides interactive menu (watch/test/build/clean)
- Watches files for changes
- Runs builds and tests
- Cleans artifacts

**Usage:**
```bash
./examples/dev-workflow.sh
```

### `ci-pipeline.sh`
A comprehensive CI/CD pipeline script that:
- Validates environment and structure
- Cleans and prepares workspace
- Builds project
- Runs tests conditionally
- Computes checksums
- Dumps build information

**Usage:**
```bash
./examples/ci-pipeline.sh
```

## Prerequisites

Before running these examples:

1. **Build the Fancy binaries:**
   ```bash
   just compile all
   # or build individually:
   just compile check
   just compile ensure
   # etc.
   ```

2. **Make scripts executable:**
   ```bash
   chmod +x examples/*.sh
   ```

3. **Adjust paths** in the scripts if your binaries are in a different location.

## Notes

- These examples assume the binaries are in `./binaries/<name>/<name>`
- Some examples use placeholder commands (like `npm`, `crystal`) - adjust to your needs
- The scripts use `set -e` to exit on errors
- Interactive examples may require terminal input

## Customization

Feel free to modify these examples to fit your specific use cases. The Fancy binaries are designed to be composable and work well together in various combinations.

