#!/bin/bash
# Fancy Installation Script
# Installs all Fancy binaries to your system

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"
REPO_URL="https://github.com/MyferIsADev/fancy.git"
TEMP_DIR="${TEMP_DIR:-/tmp/fancy-install}"

# Function to print colored output
info() {
    echo -e "${BLUE}[i]${NC} $1"
}

success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Check if running as root (for system-wide install)
check_root() {
    if [ "$EUID" -eq 0 ]; then
        INSTALL_DIR="/usr/local/bin"
        info "Running as root, installing to $INSTALL_DIR"
    else
        # Try to use user-local bin directory
        if [ -d "$HOME/.local/bin" ]; then
            INSTALL_DIR="$HOME/.local/bin"
            info "Installing to $INSTALL_DIR (add to PATH if not already)"
        else
            mkdir -p "$HOME/.local/bin"
            INSTALL_DIR="$HOME/.local/bin"
            info "Created $INSTALL_DIR and installing there"
            warning "Make sure $INSTALL_DIR is in your PATH"
        fi
    fi
}

# Check for Crystal
check_crystal() {
    if ! command -v crystal &> /dev/null; then
        error "Crystal is not installed!"
        echo ""
        echo "Please install Crystal first:"
        echo "  macOS: brew install crystal"
        echo "  Linux: See https://crystal-lang.org/install/"
        exit 1
    fi
    
    CRYSTAL_VERSION=$(crystal --version | head -n1)
    success "Found $CRYSTAL_VERSION"
}

# Get the source code
get_source() {
    # Check if we're already in the fancy directory
    if [ -f "justfile" ] && [ -d "binaries" ]; then
        info "Using current directory as source"
        SOURCE_DIR="$(pwd)"
        return
    fi
    
    # Check if repo already exists in temp
    if [ -d "$TEMP_DIR" ]; then
        info "Using existing source in $TEMP_DIR"
        SOURCE_DIR="$TEMP_DIR"
        return
    fi
    
    # Clone the repository
    info "Cloning Fancy repository..."
    mkdir -p "$(dirname "$TEMP_DIR")"
    
    if command -v git &> /dev/null; then
        git clone "$REPO_URL" "$TEMP_DIR" || {
            error "Failed to clone repository"
            exit 1
        }
        SOURCE_DIR="$TEMP_DIR"
    else
        error "Git is not installed. Please install git or run this script from the Fancy directory."
        exit 1
    fi
}

# Get list of all binaries
get_binaries_list() {
    cd "$SOURCE_DIR"
    BINARIES=$(find binaries -name "source.cr" -type f | sed 's|binaries/||' | sed 's|/source.cr||' | sort)
}

# Build all binaries
build_binaries() {
    info "Building all Fancy binaries..."
    
    cd "$SOURCE_DIR"
    
    BUILT=0
    FAILED=0
    
    for binary in $BINARIES; do
        if [ "$binary" = "new" ]; then
            continue  # Skip 'new' if it's not meant to be installed
        fi
        
        info "Building $binary..."
        
        if crystal build "binaries/$binary/source.cr" -o "binaries/$binary/$binary" 2>/dev/null; then
            # Remove debug symbols
            rm -f "binaries/$binary/$binary.dwarf" 2>/dev/null || true
            success "Built $binary"
            BUILT=$((BUILT + 1))
        else
            error "Failed to build $binary"
            FAILED=$((FAILED + 1))
        fi
    done
    
    echo ""
    success "Built $BUILT binaries"
    if [ $FAILED -gt 0 ]; then
        warning "$FAILED binaries failed to build"
    fi
}

# Install binaries
install_binaries() {
    info "Installing binaries to $INSTALL_DIR..."
    
    # Ensure install directory exists
    mkdir -p "$INSTALL_DIR"
    
    INSTALLED=0
    
    cd "$SOURCE_DIR"
    
    for binary in $BINARIES; do
        if [ "$binary" = "new" ]; then
            continue
        fi
        
        BINARY_PATH="binaries/$binary/$binary"
        
        if [ -f "$BINARY_PATH" ]; then
            # Copy to install directory
            if cp "$BINARY_PATH" "$INSTALL_DIR/$binary"; then
                chmod +x "$INSTALL_DIR/$binary"
                success "Installed $binary"
                INSTALLED=$((INSTALLED + 1))
            else
                error "Failed to install $binary"
            fi
        fi
    done
    
    echo ""
    success "Installed $INSTALLED binaries to $INSTALL_DIR"
}

# Verify installation
verify_installation() {
    info "Verifying installation..."
    
    VERIFIED=0
    MISSING=0
    
    for binary in $BINARIES; do
        if [ "$binary" = "new" ]; then
            continue
        fi
        
        if command -v "$binary" &> /dev/null; then
            success "$binary is available"
            VERIFIED=$((VERIFIED + 1))
        else
            warning "$binary is not in PATH"
            MISSING=$((MISSING + 1))
        fi
    done
    
    echo ""
    if [ $MISSING -gt 0 ]; then
        warning "Some binaries are not in your PATH"
        echo "Add $INSTALL_DIR to your PATH:"
        echo "  export PATH=\"\$PATH:$INSTALL_DIR\""
        echo ""
        echo "Add to ~/.bashrc, ~/.zshrc, or ~/.profile to make it permanent"
    fi
}

# Cleanup
cleanup() {
    if [ -d "$TEMP_DIR" ] && [ "$SOURCE_DIR" = "$TEMP_DIR" ]; then
        info "Cleaning up temporary files..."
        rm -rf "$TEMP_DIR"
    fi
}

# Main installation process
main() {
    echo ""
    echo "=========================================="
    echo "  Fancy Installation Script"
    echo "=========================================="
    echo ""
    
    check_root
    check_crystal
    get_source
    get_binaries_list
    build_binaries
    install_binaries
    verify_installation
    
    echo ""
    success "Installation complete!"
    echo ""
    echo "Try running: out \"Hello, Fancy!\" 1"
    echo ""
    
    cleanup
}

# Run main function
main

