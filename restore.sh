#!/bin/bash

# Fire TV Package Restore Script
# Re-enables all packages that were disabled by debloat.sh

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Fire TV Package Restore Script${NC}"
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

echo -e "${YELLOW}Warning: This will restore all disabled packages${NC}"
echo -n "Continue? (y/N): "
read -r response

if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "Restore cancelled"
    exit 0
fi

echo ""
echo -e "${GREEN}Finding disabled packages...${NC}"

# Get list of all disabled packages
disabled_packages=$(adb shell pm list packages -d | sed 's/package://')

if [ -z "$disabled_packages" ]; then
    echo -e "${YELLOW}No disabled packages found${NC}"
    exit 0
fi

echo -e "${YELLOW}Found $(echo "$disabled_packages" | wc -l) disabled packages${NC}"
echo ""

# Re-enable each package
while IFS= read -r package; do
    if [ -n "$package" ]; then
        echo -n "  Re-enabling: $package... "
        
        result=$(adb shell pm enable "$package" 2>&1)
        
        if echo "$result" | grep -q "new state: enabled"; then
            echo -e "${GREEN}✓${NC}"
        else
            echo -e "${RED}✗${NC}"
        fi
    fi
done <<< "$disabled_packages"

echo ""
echo -e "${GREEN}Restore complete!${NC}"
echo ""
echo -e "Restart your Fire TV for changes to take full effect"
echo -n "Restart now? (y/N): "
read -r restart_response

if [[ "$restart_response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "Restarting Fire TV..."
    adb reboot
    echo -e "${GREEN}Fire TV is rebooting...${NC}"
fi
