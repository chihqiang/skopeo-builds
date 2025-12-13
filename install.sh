#!/usr/bin/env bash
set -euo pipefail

VERSION="${SKOPEO_VERSION:-"v1.21.0"}"
BASE_URL="https://github.com/chihqiang/skopeo-builds/releases/download/${VERSION}"
INSTALL_DIR="/usr/local/bin"

# Ensure temp dir is cleaned on exit or error
TEMP_DIR=$(mktemp -d)
echo "📁 Temporary directory: $TEMP_DIR" 
cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

# Detect OS
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"

# Detect ARCH
ARCH="$(uname -m)"
case "$ARCH" in
    x86_64) ARCH="amd64" ;;
    aarch64 | arm64) ARCH="arm64" ;;
    ppc64le) ARCH="ppc64le" ;;
    *) echo "❌ Unsupported architecture: $ARCH"; exit 1 ;;
esac

# Map OS naming to download file naming
case "$OS" in
    darwin) FILE="skopeo_darwin_${ARCH}.tar.gz" ;;
    linux)  FILE="skopeo_linux_${ARCH}.tar.gz" ;;
    *) echo "❌ Unsupported OS: $OS"; exit 1 ;;
esac

DOWNLOAD_URL="${BASE_URL}/${FILE}"

# Check if Skopeo already exists
if command -v skopeo >/dev/null 2>&1; then
    echo "⚠️  Skopeo is already installed at $(command -v skopeo)"
fi

echo "👉 Detected OS: $OS"
echo "👉 Detected Architecture: $ARCH"
echo "👉 Download URL: $DOWNLOAD_URL"
echo "👉 Installing into: $INSTALL_DIR"

# Ensure install dir exists
sudo mkdir -p "$INSTALL_DIR"
cd "$TEMP_DIR"

# Download binary
echo "⬇️  Downloading $FILE..."
curl -fL -o skopeo.tar.gz "$DOWNLOAD_URL"

# Extract
echo "📦 Extracting..."
tar -xzf skopeo.tar.gz

# Install
echo "🚀 Installing..."
sudo mv skopeo "$INSTALL_DIR/"
sudo chmod +x "$INSTALL_DIR/skopeo"

echo "✅ Skopeo installation completed!"
echo "📌 Installed binary: $INSTALL_DIR/skopeo"

# Show installed version
"$INSTALL_DIR/skopeo" --version
