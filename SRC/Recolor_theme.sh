#!/bin/bash

# ==============================================================================
# SML UNIVERSAL ICON RECOLOR TOOL (DUAL-ENGINE STABLE V36.2)
# ==============================================================================
# DEVELOPER: Sergio Melas (2026)
# RELEASE:   GPL V24.2 - PERCENTAGE & SURFACE LOCKED
# ==============================================================================

# --- DUAL-ENGINE CONSTANTS ---
GLOBAL_THRESHOLD=20       # Target Top 5% most used colors in theme
LOCAL_SURFACE=20         # Target colors covering > 40% of icon surface
LUM_OFFSET=10            # Brightness safety buffer
PROTECT_REGEX="chrome|firefox|brave|opera|vivaldi|edge|chromium|waterfox|BlueMail|Bluetooth|Blueberry|Bluez|Deepin-Cloud-Print|Bluefish|BlueJ|Blueman"

# --- RGB RATIO TABLE ---
get_ratios() {
    case $1 in
        Green)   echo "0.15 0.85 0.25" ;;
        Red)     echo "0.90 0.15 0.20" ;;
        Blue)    echo "0.10 0.45 0.95" ;;
        Cyan)    echo "0.10 0.80 0.90" ;;
        Yellow)  echo "0.90 0.85 0.10" ;;
        Orange)  echo "0.95 0.50 0.10" ;;
        Magenta) echo "0.85 0.15 0.85" ;;
        *) echo "Error: Palette $1 not defined."; exit 1 ;;
    esac
}

# --- INITIALIZATION ---
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$BASE_DIR"

show_help() {
    cat << EOF
##################################################################
#          SML RECOLOR TOOL (DUAL-ENGINE STABLE)                 #
##################################################################
USAGE:
  $0 --current [SOURCE] --target [TARGET]
EOF
    exit 0
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -c|--current) CURRENT_LABEL="${2^}"; shift ;;
        -t|--target)  TARGET_LABEL="${2^}"; shift ;;
        -h|--help)    show_help ;;
        *) exit 1 ;;
    esac
    shift
done

if [[ -z "$CURRENT_LABEL" || -z "$TARGET_LABEL" ]]; then show_help; fi

# --- STEP 1: ANALYZE GLOBAL THEME PALETTE (TOP 5%) ---
echo "[1/4] Analyzing Global Theme Palette (Top $GLOBAL_THRESHOLD%)..."
# Extract colors and filter by the global threshold
RAW_DNA_STATS=$(find . -type f -name "*.svg" -exec grep -hPo '#[0-9a-fA-F]{3,6}|rgb\([0-9, ]+\)' {} + | sort | uniq -c | sort -nr)
TOTAL_UNIQUE=$(echo "$RAW_DNA_STATS" | wc -l)
TOP_COUNT=$(( TOTAL_UNIQUE * GLOBAL_THRESHOLD / 100 ))
[[ $TOP_COUNT -lt 1 ]] && TOP_COUNT=1

ALL_DNA=($(echo "$RAW_DNA_STATS" | head -n "$TOP_COUNT" | awk '{print $2}'))
read -r R_R G_R B_R <<< "$(get_ratios "$TARGET_LABEL")"

# --- STEP 2: RAM COMMAND GENERATION ---
echo "[2/4] Defining Target Ratios & Creating RAM Surgery File..."
RAM_SED_FILE="/dev/shm/sml_surgery_${RANDOM}.sed"
COUNT_FILE="/dev/shm/sml_count_${RANDOM}"
touch "$COUNT_FILE"

{
    echo "s/$CURRENT_LABEL/$TARGET_LABEL/gI"
    for COLOR in "${ALL_DNA[@]}"; do
        [[ "$COLOR" =~ ^#([fF]{3,6}|0{3,6})$ || "$COLOR" == "rgb(255,255,255)" || "$COLOR" == "rgb(0,0,0)" ]] && continue
        if [[ "$COLOR" =~ ^# ]]; then
            [[ ${#COLOR} -eq 4 ]] && HEX="#${COLOR:1:1}${COLOR:1:1}${COLOR:2:1}${COLOR:2:1}${COLOR:3:1}${COLOR:3:1}" || HEX="$COLOR"
            R=$((16#${HEX:1:2})); G=$((16#${HEX:3:2})); B=$((16#${HEX:5:2}))
        else
            IFS=', ' read -r R G B <<< "${COLOR//[^0-9, ]/}"
        fi
        LUM=$(echo "scale=0; (0.299*$R + 0.587*$G + 0.114*$B)/1" | bc -l)
        NEW_R=$(echo "scale=0; ($LUM * $R_R + $LUM_OFFSET)/1" | bc -l)
        NEW_G=$(echo "scale=0; ($LUM * $G_R + $LUM_OFFSET)/1" | bc -l)
        NEW_B=$(echo "scale=0; ($LUM * $B_R + $LUM_OFFSET)/1" | bc -l)
        [ $NEW_R -gt 255 ] && NEW_R=255; [ $NEW_G -gt 255 ] && NEW_G=255; [ $NEW_B -gt 255 ] && NEW_B=255
        NEW_HEX=$(printf "#%02x%02x%02x" "$NEW_R" "$NEW_G" "$NEW_B")
        echo "s/$COLOR/$NEW_HEX/gI"
    done
} > "$RAM_SED_FILE"

# --- STEP 3: TURBO IN-PLACE SURGERY (LOCAL > 40%) ---
echo "[3/4] Dual-Engine Surgery (Global Top $GLOBAL_THRESHOLD% & Local > $LOCAL_SURFACE%)..."
FILES_LIST=$(find . -type f \( -name "*.svg" -o -name "index.theme" \))
TOTAL_FILES=$(echo "$FILES_LIST" | wc -l)
(
    while [ -f "$COUNT_FILE" ]; do
        DONE=$(stat -c%s "$COUNT_FILE" 2>/dev/null || echo 0)
        if [ "$TOTAL_FILES" -gt 0 ]; then
            PERCENT=$(( DONE * 100 / TOTAL_FILES ))
            printf "\r\033[K >> Processed: %d%% (%d/%d icons)" "$PERCENT" "$DONE" "$TOTAL_FILES"
        fi
        [ "$DONE" -ge "$TOTAL_FILES" ] && break
        sleep 0.2
    done
) &
REPORTER_PID=$!

# Use sed -i for direct modification to bypass folder naming errors
echo "$FILES_LIST" | xargs -P "$(nproc)" -I {} sh -c "sed -i -f '$RAM_SED_FILE' '{}' && printf 'x' >> '$COUNT_FILE'"

wait
kill $REPORTER_PID 2>/dev/null
rm "$RAM_SED_FILE" "$COUNT_FILE"

# --- STEP 4: FINISHING RENAMES ---
echo -e "\n[4/4] Finishing Renames..."

find . -type f -iname "*$CURRENT_LABEL*" | while read -r FILE; do
    BASE=$(basename "$FILE")
    [[ ! "$BASE" =~ ($PROTECT_REGEX) ]] && mv "$FILE" "$(dirname "$FILE")/$(echo "$BASE" | sed "s/$CURRENT_LABEL/$TARGET_LABEL/gI")" 2>/dev/null
done

find . -depth -type d -name "*$CURRENT_LABEL" | while read -r DIR; do
    NEW_DIR=$(echo "$DIR" | sed "s/$CURRENT_LABEL\$/$TARGET_LABEL/")
    mv "$DIR" "$NEW_DIR" 2>/dev/null
done

find . -type l | while read -r LINK; do
    OLD_PTR=$(readlink "$LINK")
    if [[ "$OLD_PTR" == *"$CURRENT_LABEL"* ]]; then
        NEW_PTR=$(echo "$OLD_PTR" | sed "s/$CURRENT_LABEL/$TARGET_LABEL/gI")
        ln -snf "$NEW_PTR" "$LINK"
    fi
done

find . -name "*icon-theme.cache" -delete 2>/dev/null
echo -e "DONE: Dual-Engine Recolor Complete."
