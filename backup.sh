#!/bin/bash

# Fire TV Package State Backup Script
# Creates a backup of current package states before debloating

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

BACKUP_DIR="backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/firetv_backup_${TIMESTAMP}.txt"

echo -e "${GREEN}Fire TV Package State Backup Script${NC}"
echo ""

# Check if ADB is installed
if ! command -v adb &> /dev/null; then
    echo -e "${RED}Error: ADB is not installed${NC}"
    exit 1
fi

# Check if device is connected
if ! adb devices | grep -q "device$"; then
    echo -e "${RED}Error: No Fire TV device connected${NC}"
    exit 1
fi

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

echo -e "${YELLOW}Creating backup...${NC}"
echo ""

# Get device info
echo "=== Device Information ===" > "$BACKUP_FILE"
echo "Date: $(date)" >> "$BACKUP_FILE"
echo "Device Model: $(adb shell getprop ro.product.model)" >> "$BACKUP_FILE"
echo "Fire OS Version: $(adb shell getprop ro.build.version.name)" >> "$BACKUP_FILE"
echo "Android Version: $(adb shell getprop ro.build.version.release)" >> "$BACKUP_FILE"
echo "" >> "$BACKUP_FILE"

# Get all packages
echo "=== All Installed Packages ===" >> "$BACKUP_FILE"
adb shell pm list packages | sort >> "$BACKUP_FILE"
echo "" >> "$BACKUP_FILE"

# Get disabled packages
echo "=== Disabled Packages ===" >> "$BACKUP_FILE"
adb shell pm list packages -d | sort >> "$BACKUP_FILE"
echo "" >> "$BACKUP_FILE"

# Get system packages
echo "=== System Packages ===" >> "$BACKUP_FILE"
adb shell pm list packages -s | sort >> "$BACKUP_FILE"
echo "" >> "$BACKUP_FILE"

# Get third-party packages
echo "=== Third-party Packages ===" >> "$BACKUP_FILE"
adb shell pm list packages -3 | sort >> "$BACKUP_FILE"
echo "" >> "$BACKUP_FILE"

# Get permissions for critical packages
echo "=== Package Permissions ===" >> "$BACKUP_FILE"
for package in $(adb shell pm list packages | sed 's/package://'); do
    echo "Package: $package" >> "$BACKUP_FILE"
    adb shell dumpsys package "$package" | grep "granted=true" >> "$BACKUP_FILE" 2>/dev/null || true
    echo "" >> "$BACKUP_FILE"
done

echo -e "${GREEN}✓ Backup created: ${BACKUP_FILE}${NC}"
echo ""
echo "Package count:"
echo "  Total: $(adb shell pm list packages | wc -l)"
echo "  System: $(adb shell pm list packages -s | wc -l)"
echo "  Third-party: $(adb shell pm list packages -3 | wc -l)"
echo "  Disabled: $(adb shell pm list packages -d | wc -l)"
echo ""
echo -e "${YELLOW}Keep this backup file safe before proceeding with debloat!${NC}"
