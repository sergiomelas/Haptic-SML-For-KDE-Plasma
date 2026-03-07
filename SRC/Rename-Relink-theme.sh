#!/bin/bash

# ==============================================================================
# HAPTIC-SML INFRASTRUCTURE FINALIZER (V34.5)
# ==============================================================================
# DEVELOPER: Sergio Melas (2026)
# RELEASE:   GPL V22.5 - RELATIVE PATH STABLE
# ==============================================================================

# CONFIGURATION
NEW_LABEL="Cyan"

# The base names of your folders as seen in your screenshot
TARGET_DIRS=(
    "Haptic-Kore"
    "Haptic-Kore-light"
    "Haptic-Kore-light-panel"
)

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$BASE_DIR"

# --- STEP 1: FOLDER RENAMING (NO-SUFFIX TO NEW-SUFFIX) ---
echo "[1/2] Appending -$NEW_LABEL to base directories..."
for DIR in "${TARGET_DIRS[@]}"; do
    if [ -d "$DIR" ] && [[ ! "$DIR" == *"-${NEW_LABEL}" ]]; then
        echo "  >> Renaming Folder: $DIR -> ${DIR}-${NEW_LABEL}"
        mv "$DIR" "${DIR}-${NEW_LABEL}" 2>/dev/null
    fi
done

# --- STEP 2: RELATIVE LINK HEALING ---
echo "[2/2] Healing Relative Symlinks..."
find . -type l | while read -r LINK; do
    OLD_PTR=$(readlink "$LINK")
    NEW_PTR="$OLD_PTR"

    # 1. Forcefully swap "Blue" for the new label
    if [[ "$NEW_PTR" == *"Blue"* ]]; then
        NEW_PTR=$(echo "$NEW_PTR" | sed "s/Blue/$NEW_LABEL/g")
    fi

    # 2. Ensure base names in the relative path also get the suffix
    for DIR in "${TARGET_DIRS[@]}"; do
        if [[ "$NEW_PTR" == *"$DIR"* ]] && [[ ! "$NEW_PTR" == *"${DIR}-${NEW_LABEL}"* ]]; then
            NEW_PTR=$(echo "$NEW_PTR" | sed "s|$DIR|$DIR-$NEW_LABEL|g")
        fi
    done

    # Only rewrite if the path actually changed
    if [ "$OLD_PTR" != "$NEW_PTR" ]; then
        ln -snf "$NEW_PTR" "$LINK"
    fi
done

echo -e "\nDONE: Relative infrastructure is now synchronized to $NEW_LABEL."
