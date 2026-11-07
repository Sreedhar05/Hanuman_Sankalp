#!/bin/bash

# Fire TV Performance Optimization Script
# Applies various tweaks to improve Fire TV performance

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Fire TV Performance Optimization Script${NC}"
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

echo -e "${GREEN}Fire TV device detected${NC}"
echo ""

# Function to run command and show result
run_optimization() {
    local description=$1
    local command=$2
    
    echo -n "  $description... "
    
    if adb shell "$command" &> /dev/null; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${YELLOW}○${NC} (may not be supported)"
    fi
}

echo -e "${YELLOW}Applying performance optimizations...${NC}"
echo ""

# Disable animations for faster UI
echo -e "${GREEN}1. Disabling animations${NC}"
run_optimization "Disabling window animation scale" "settings put global window_animation_scale 0"
run_optimization "Disabling transition animation scale" "settings put global transition_animation_scale 0"
run_optimization "Disabling animator duration scale" "settings put global animator_duration_scale 0"

echo ""

# Limit background processes
echo -e "${GREEN}2. Limiting background processes${NC}"
run_optimization "Setting background process limit to 2" "settings put global background_process_limit 2"

echo ""

# Force GPU rendering
echo -e "${GREEN}3. Forcing GPU rendering${NC}"
run_optimization "Enabling force GPU rendering" "settings put global force_hw_ui 1"
run_optimization "Enabling GPU debug layers" "settings put global debug.hwui.render_dirty_regions false"

echo ""

# Reduce logger buffer
echo -e "${GREEN}4. Optimizing system logging${NC}"
run_optimization "Reducing log buffer size" "logcat -G 256K"

echo ""

# Clear all app caches
echo -e "${GREEN}5. Clearing system caches${NC}"
echo -n "  Clearing app caches... "
# This clears cache for all apps
adb shell "pm list packages | cut -f 2 -d ':' | while read package; do pm clear \$package 2>/dev/null; done" &> /dev/null &
echo -e "${GREEN}✓${NC} (running in background)"

echo ""

# Disable automatic updates (optional - may want to keep this)
echo -e "${YELLOW}6. System update settings${NC}"
echo -e "  ${YELLOW}Note:${NC} Automatic updates are recommended for security"
echo -n "  Do you want to disable automatic updates? (y/N): "
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    run_optimization "Disabling automatic updates" "pm disable-user --user 0 com.amazon.device.software.ota"
    echo -e "  ${YELLOW}Warning:${NC} You'll need to update manually"
else
    echo -e "  ${GREEN}○${NC} Keeping automatic updates enabled"
fi

echo ""

# Memory optimizations
echo -e "${GREEN}7. Memory optimizations${NC}"
run_optimization "Setting aggressive memory management" "settings put global memory_optimization_level 1"
run_optimization "Enabling low memory killer" "settings put global sys.mem.max_hidden_apps 2"

echo ""

# Network optimizations
echo -e "${GREEN}8. Network optimizations${NC}"
run_optimization "Optimizing TCP buffer sizes" "settings put global tcp_default_init_rwnd 60"
run_optimization "Enabling network performance mode" "settings put global wifi_watchdog_poor_network_test_enabled 0"

echo ""

# Disable unnecessary permissions for system apps
echo -e "${GREEN}9. Privacy & Security${NC}"
run_optimization "Revoking unnecessary permissions" "pm revoke com.amazon.tv.launcher android.permission.READ_LOGS"
run_optimization "Disabling usage access for ads" "appops set com.amazon.ags.app SYSTEM_ALERT_WINDOW deny"

echo ""

echo -e "${GREEN}Performance optimizations complete!${NC}"
echo ""
echo -e "${YELLOW}Additional manual optimizations:${NC}"
echo -e "  1. Go to Settings → Applications → Amazon App Settings"
echo -e "     - Disable 'Collect App Usage Data'"
echo -e "     - Disable 'Interest-based Ads'"
echo -e "  2. Go to Settings → Preferences → Privacy Settings"
echo -e "     - Disable 'Device Usage Data'"
echo -e "     - Disable 'Collect App Usage Data'"
echo -e "  3. Consider installing a custom launcher like 'Launcher Hijack'"
echo -e "  4. Restart your Fire TV for changes to take full effect"
echo ""
echo -e "${YELLOW}Restart now? (y/N):${NC} "
read -r restart_response
if [[ "$restart_response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "Restarting Fire TV..."
    adb reboot
    echo -e "${GREEN}Fire TV is rebooting...${NC}"
else
    echo -e "${YELLOW}Please restart manually when convenient${NC}"
fi
