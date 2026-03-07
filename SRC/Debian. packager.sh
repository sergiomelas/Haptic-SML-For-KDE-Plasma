#!/bin/bash

##################################################################
#                        SML MAGIC TOOLS                         #
#          Developed for bash by Sergio Melas 2026               #
##################################################################

# 1. FORCE DIRECTORY
cd "$(dirname "$0")"

# 2. CONFIGURATION
PACKAGE_NAME="haptic-kore-sml-cyan"
VERSION="1.0.0"
ARCH="all"
DEB_FILE="${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"
BUILD_DIR="debian_build"

echo "--- [1/4] Preparing Build Environment ---"
rm -rf "$BUILD_DIR"
rm -f "$DEB_FILE"
mkdir -p "$BUILD_DIR/DEBIAN"
mkdir -p "$BUILD_DIR/usr/share/icons"

# 3. CONTROL FILE
cat << EOF > "$BUILD_DIR/DEBIAN/control"
Package: $PACKAGE_NAME
Version: $VERSION
Section: misc
Priority: optional
Architecture: $ARCH
Maintainer: Sergio Melas <sergiomelas@gmail.com>
Description: Haptic Kore Icon Suite - Final Visibility Fix
EOF

# 4. REFRESH & MIGRATE (THE FINAL FIX)
echo "--- [2/4] Scanning and Fixing Source Folders ---"

THEME_COUNT=0

# Use find to catch every theme folder
while IFS= read -r -d '' THEME_FILE; do

    THEME_SRC_DIR=$(dirname "$THEME_FILE")
    THEME_NAME=$(basename "$THEME_SRC_DIR")

    echo ">> Processing: $THEME_NAME"
    ((THEME_COUNT++))

    # A. CLEAN OLD CACHE (Prevents "Ghosting" in System Settings)
    rm -f "$THEME_SRC_DIR/icon-theme.cache"

    # B. REFRESH CACHE IN SOURCE (Your instruction)
    # We use -t to ensure the theme index is validated
    gtk-update-icon-cache -f -t -q "$THEME_SRC_DIR" 2>/dev/null

    # C. MIGRATE TO BUILD DIR
    # We ensure the theme folder is placed DIRECTLY in /usr/share/icons/
    TARGET_PATH="$BUILD_DIR/usr/share/icons/$THEME_NAME"
    mkdir -p "$TARGET_PATH"

    # Sync with -L to resolve any symlinks that might be breaking the theme
    rsync -avL "$THEME_SRC_DIR/" "$TARGET_PATH/" \
        --exclude="*.deb" \
        --exclude="*.sh" \
        --exclude="readme.txt" \
        --exclude=".git" > /dev/null

done < <(find . -mindepth 2 -name "index.theme" -not -path "./$BUILD_DIR/*" -print0)

echo "--- TOTAL THEMES CAPTURED: $THEME_COUNT ---"

# 5. PERMISSIONS (Crucial for System Settings visibility)
echo "--- [3/4] Normalizing Permissions ---"
# Folders must be 755, Files must be 644
chmod -R 755 "$BUILD_DIR/DEBIAN"
find "$BUILD_DIR/usr" -type d -exec chmod 755 {} +
find "$BUILD_DIR/usr" -type f -exec chmod 644 {} +

# 6. FINAL BUILD
echo "--- [4/4] Building Package ---"
# We use fakeroot to ensure the system treats the files correctly
if command -v fakeroot >/dev/null 2>&1; then
    fakeroot dpkg-deb --build "$BUILD_DIR" "$DEB_FILE"
else
    dpkg-deb --build "$BUILD_DIR" "$DEB_FILE"
fi

rm -rf "$BUILD_DIR"

echo "------------------------------------------------"
echo "SUCCESS: Created $DEB_FILE"
echo "INSTALL: sudo dpkg -i $DEB_FILE"
echo "------------------------------------------------"
