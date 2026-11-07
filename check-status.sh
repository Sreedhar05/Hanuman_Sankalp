#!/bin/bash

# Fire TV Status Check Script
# Shows current state of packages and system settings

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}Fire TV Status Check${NC}"
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

echo -e "${BLUE}=== Device Information ===${NC}"
echo "Model: $(adb shell getprop ro.product.model)"
echo "Fire OS: $(adb shell getprop ro.build.version.name)"
echo "Android: $(adb shell getprop ro.build.version.release)"
echo ""

echo -e "${BLUE}=== Package Statistics ===${NC}"
total_packages=$(adb shell pm list packages | wc -l)
disabled_packages=$(adb shell pm list packages -d | wc -l)
system_packages=$(adb shell pm list packages -s | wc -l)
third_party=$(adb shell pm list packages -3 | wc -l)

echo "Total packages: $total_packages"
echo "System packages: $system_packages"
echo "Third-party packages: $third_party"
echo -e "Disabled packages: ${YELLOW}$disabled_packages${NC}"
echo ""

if [ "$disabled_packages" -gt 0 ]; then
    echo -e "${BLUE}=== Disabled Packages ===${NC}"
    adb shell pm list packages -d | sed 's/package:/  - /'
    echo ""
fi

echo -e "${BLUE}=== Performance Settings ===${NC}"

# Check animation settings
window_anim=$(adb shell settings get global window_animation_scale)
transition_anim=$(adb shell settings get global transition_animation_scale)
animator_duration=$(adb shell settings get global animator_duration_scale)

echo -n "Animations: "
if [ "$window_anim" = "0" ] && [ "$transition_anim" = "0" ] && [ "$animator_duration" = "0" ]; then
    echo -e "${GREEN}Disabled ✓${NC}"
else
    echo -e "${YELLOW}Enabled${NC}"
fi

# Check background process limit
bg_limit=$(adb shell settings get global background_process_limit 2>/dev/null || echo "null")
echo -n "Background process limit: "
if [ "$bg_limit" != "null" ]; then
    echo -e "${GREEN}$bg_limit${NC}"
else
    echo -e "${YELLOW}Not set${NC}"
fi

# Check GPU rendering
gpu_render=$(adb shell settings get global force_hw_ui 2>/dev/null || echo "null")
echo -n "Force GPU rendering: "
if [ "$gpu_render" = "1" ]; then
    echo -e "${GREEN}Enabled ✓${NC}"
else
    echo -e "${YELLOW}Disabled${NC}"
fi

echo ""

echo -e "${BLUE}=== Memory Status ===${NC}"
adb shell dumpsys meminfo | grep -A 5 "Total RAM"
echo ""

echo -e "${BLUE}=== Storage Status ===${NC}"
adb shell df -h /data | tail -n 1 | awk '{print "Used: " $3 " / " $2 " (" $5 " full)"}'
echo ""

echo -e "${BLUE}=== Running Services ===${NC}"
running_services=$(adb shell dumpsys activity services | grep -c "ServiceRecord" || echo "0")
echo "Active services: $running_services"
echo ""

echo -e "${BLUE}=== Network Status ===${NC}"
adb shell dumpsys wifi | grep "mNetworkInfo" | head -n 1
echo ""

# Check for common bloatware
echo -e "${BLUE}=== Bloatware Status ===${NC}"

check_package() {
    local package=$1
    local name=$2
    
    if adb shell pm list packages | grep -q "^package:${package}$"; then
        if adb shell pm list packages -d | grep -q "^package:${package}$"; then
            echo -e "  $name: ${GREEN}Disabled ✓${NC}"
        else
            echo -e "  $name: ${YELLOW}Enabled${NC}"
        fi
    else
        echo -e "  $name: ${BLUE}Not installed${NC}"
    fi
}

check_package "com.amazon.tahoe" "Amazon Video"
check_package "com.amazon.venezia" "App Store"
check_package "com.amazon.kindle.otter" "Kindle"
check_package "com.amazon.photos.importer" "Amazon Photos"
check_package "com.amazon.shoptv.client" "Shop TV"
check_package "com.amazon.hedwig" "Goodreads"
check_package "com.audible.application.kindle" "Audible"
check_package "com.amazon.music.tv" "Amazon Music"
check_package "com.amazon.ags.app" "Game Services"
check_package "com.amazon.advertisingidsettings" "Ad Services"

echo ""
echo -e "${GREEN}Status check complete!${NC}"
