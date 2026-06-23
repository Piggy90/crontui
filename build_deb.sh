#!/usr/bin/env bash
# ==============================================================================
#  CRONTUI DEBIAN PACKAGE BUILDER
# ==============================================================================

# Package configuration
PKG_NAME="crontui"
VERSION="1.1.1"
ARCH="all"
PKG_DIR="${PKG_NAME}_${VERSION}_${ARCH}"

echo "Building Debian package for CronTUI v${VERSION}..."

# Clean up any existing build dir
rm -rf "$PKG_DIR"
rm -f "${PKG_DIR}.deb"

# Create directory structure
mkdir -p "${PKG_DIR}/DEBIAN"
mkdir -p "${PKG_DIR}/usr/bin"

# Create control file
cat << EOF > "${PKG_DIR}/DEBIAN/control"
Package: ${PKG_NAME}
Version: ${VERSION}
Section: utils
Priority: optional
Architecture: ${ARCH}
Maintainer: Piggy90 <piggy90@github.com>
Description: Terminal-based visualizer and manager for cronjobs.
 CronTUI provides visual week, day, month, and year heatmap grids
 for managing, inspecting, and testing cronjobs on Unix systems.
Requires: python3
EOF

# Copy executable
cp crontui "${PKG_DIR}/usr/bin/crontui"
chmod 755 "${PKG_DIR}/usr/bin/crontui"

# Build package
if command -v dpkg-deb >/dev/null 2>&1; then
    dpkg-deb --build "$PKG_DIR"
    echo "============================================================"
    echo -e "\033[0;32m✔ SUCCESS:\033[0m Created package ${PKG_DIR}.deb"
    echo "Install it using: sudo dpkg -i ${PKG_DIR}.deb"
    echo "============================================================"
else
    echo "============================================================"
    echo -e "\033[0;31m✘ ERROR:\033[0m dpkg-deb command not found. Cannot build package."
    echo "============================================================"
    exit 1
fi
