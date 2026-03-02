#!/usr/bin/env bash
set -euo pipefail

# -----------------------------
# Binary name and installation directory
# -----------------------------
BIN_NAME="skopeo"
INSTALL_DIR="/usr/local/bin"
VERSION="${SKOPEO_VERSION:-latest}"
GH_REPO="chihqiang/skopeo-builds"

# -----------------------------
# Required command check
# -----------------------------
for cmd in curl tar sudo uname mktemp; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "❌ Required command not found: $cmd"
        exit 1
    fi
done

# -----------------------------
# Build download URL
# -----------------------------
if [[ "$VERSION" == "latest" ]]; then
    BASE_URL="https://github.com/${GH_REPO}/releases/latest/download"
else
    BASE_URL="https://github.com/${GH_REPO}/releases/download/${VERSION}"
fi

# -----------------------------
# Temp directory (auto cleanup)
# -----------------------------
TEMP_DIR="$(mktemp -d)"
echo "📁 Temporary directory: $TEMP_DIR"

cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT
# -----------------------------
# Detect Architecture
# -----------------------------
ARCH="$(uname -m)"
case "$ARCH" in
    x86_64) ARCH="amd64" ;;
    aarch64 | arm64) ARCH="arm64" ;;
    ppc64le) ARCH="ppc64le" ;;
    *)
        echo "❌ Unsupported architecture: $ARCH"
        exit 1
        ;;
esac


# -----------------------------
# Map OS to file naming
# -----------------------------
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
case "$OS" in
    darwin|linux)  # 用 | 分隔多个匹配项
        filename="${BIN_NAME}_${OS}_${ARCH}.tar.gz"
        ;;
    *)
        echo "❌ Unsupported OS: $OS"
        exit 1
        ;;
esac
DOWNLOAD_URL="${BASE_URL}/${filename}"

# -----------------------------
# Already installed check
# -----------------------------
if command -v "${BIN_NAME}" >/dev/null 2>&1; then
    echo "⚠️  ${BIN_NAME} already installed at $(command -v "${BIN_NAME}")"
    read -r -p "Reinstall? [y/N]: " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
    fi
fi

echo "👉 Detected OS: $OS"
echo "👉 Detected Architecture: $ARCH"
echo "👉 Download URL: $DOWNLOAD_URL"
echo "👉 Installing into: $INSTALL_DIR"

# -----------------------------
# Prepare install dir
# -----------------------------
sudo mkdir -p "$INSTALL_DIR"
cd "$TEMP_DIR"

# -----------------------------
# Download binary
# -----------------------------
echo "⬇️  Downloading $filename..."
curl -fL -o "${BIN_NAME}.tar.gz" "$DOWNLOAD_URL"

# -----------------------------
# Extract
# -----------------------------
echo "📦 Extracting..."
tar -xzf "${BIN_NAME}.tar.gz"

if [[ ! -f "${BIN_NAME}" ]]; then
    echo "❌ Extracted binary not found!"
    exit 1
fi

# -----------------------------
# Install
# -----------------------------
echo "🚀 Installing..."
sudo install -m 0755 "${BIN_NAME}" "$INSTALL_DIR/"

echo "✅ ${BIN_NAME} installation completed!"
echo "📌 Installed binary: ${INSTALL_DIR}/${BIN_NAME}"

# -----------------------------
# Show version
# -----------------------------
echo "📦 Installed version:"
"${INSTALL_DIR}/${BIN_NAME}" --version