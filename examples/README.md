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
- Uses `timer` for build timeout
- Mentions `monitor` for disk space checking
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
- Uses `truncate` to clear old log files (with backup)
- Conditionally installs dependencies
- Builds and verifies output
- Uses `randomize` to generate build IDs

**Usage:**
```bash
./examples/build.sh
```

### `setup.sh`
An interactive project setup script that:
- Prompts for project name and environment
- Creates project structure
- Uses `randomize` to generate random port numbers
- Uses `truncate` to clean old config files (with backup)
- Generates configuration files
- Sets environment variables
- Verifies setup completion

**Usage:**
```bash
./examples/setup.sh
```

### `backup.sh`
A backup script with verification that:
- Uses `randomize` to generate unique backup IDs
- Creates timestamped backup directories
- Verifies source files exist
- Computes checksums for verification
- Copies files safely
- Verifies backup integrity
- Uses `truncate` to clean old backup logs

**Usage:**
```bash
./examples/backup.sh
```

### `dev-workflow.sh`
A development workflow helper that:
- Checks development environment
- Provides interactive menu (watch/test/build/clean/monitor)
- Watches files for changes
- Uses `monitor` to monitor disk/CPU during development
- Runs builds and tests
- Cleans artifacts
- Uses `truncate` to clean log files

**Usage:**
```bash
./examples/dev-workflow.sh
```

### `ci-pipeline.sh`
A comprehensive CI/CD pipeline script that:
- Validates environment and structure
- Cleans and prepares workspace
- Uses `truncate` to clear CI logs (with backup)
- Uses `timer` for build timeout
- Builds project
- Runs tests conditionally
- Uses `randomize` to generate build numbers
- Computes checksums
- Dumps build information
- Mentions `monitor` for continuous disk monitoring

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

## Featured Binaries in Examples

These examples demonstrate the following Fancy binaries:

- **Core utilities**: `check`, `ensure`, `manifest`, `guard`, `envset`, `confirm`, `ask`
- **File operations**: `touchup`, `clean`, `copycat`, `truncate`
- **Output & monitoring**: `out`, `watch`, `monitor`, `dump`
- **Logic & flow**: `eq`, `timer`
- **Data generation**: `randomize`, `hashit`

## Notes

- These examples assume the binaries are installed and available in your PATH
- Some examples use placeholder commands (like `npm`, `crystal`) - adjust to your needs
- The scripts use `set -e` to exit on errors
- Interactive examples may require terminal input
- `monitor` runs continuously - use Ctrl+C to stop it

## Customization

Feel free to modify these examples to fit your specific use cases. The Fancy binaries are designed to be composable and work well together in various combinations.

