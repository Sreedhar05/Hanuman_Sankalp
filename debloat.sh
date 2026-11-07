#!/bin/bash

# Fire TV Debloat Script
# Removes bloatware and unwanted Amazon services from Fire TV devices

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

MODE="safe"
DRY_RUN=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --aggressive)
            MODE="aggressive"
            shift
            ;;
        --safe)
            MODE="safe"
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--safe|--aggressive] [--dry-run]"
            exit 1
            ;;
    esac
done

echo -e "${GREEN}Fire TV Debloat Script${NC}"
echo -e "Mode: ${YELLOW}${MODE}${NC}"
echo ""

# Check if ADB is installed
if ! command -v adb &> /dev/null; then
    echo -e "${RED}Error: ADB is not installed${NC}"
    echo "Please install Android Debug Bridge (ADB) first"
    exit 1
fi

# Check if device is connected
if ! adb devices | grep -q "device$"; then
    echo -e "${RED}Error: No Fire TV device connected${NC}"
    echo "Please connect to your Fire TV using: adb connect <IP_ADDRESS>:5555"
    exit 1
fi

echo -e "${GREEN}Fire TV device detected${NC}"
echo ""

# Safe packages to disable (minimal risk)
SAFE_PACKAGES=(
    # Amazon bloatware
    "com.amazon.tahoe"                          # Amazon Video (if using other apps)
    "com.amazon.venezia"                        # Amazon App Store (alternative: Aurora Store)
    "com.amazon.kindle.otter"                   # Kindle
    "com.amazon.ods.kindleconnect"             # Kindle connectivity
    "amazon.alexa.tablet"                       # Alexa app
    "com.amazon.ftv.glorialist"                # Watchlist
    "com.amazon.tmm.tutorial"                  # Tips & Tutorials
    "com.amazon.dp.fbappsandservices"          # Facebook App Services
    "com.amazon.photos.importer"                # Amazon Photos
    "com.amazon.clouddrive.photos"             # Amazon Photos Cloud
    "com.amazon.shoptv.client"                 # Amazon Shop TV
    "com.amazon.advertisingidsettings"         # Advertising ID Settings
    
    # Third-party bloat
    "com.amazon.hedwig"                         # Goodreads
    "com.audible.application.kindle"           # Audible
    "com.amazon.music.tv"                       # Amazon Music
    
    # Advertising & Telemetry
    "com.amazon.ags.app"                        # Amazon Game Service
    "com.amazon.device.messaging"               # Device Messaging
    "com.amazon.device.messaging.sdk.internal.library" # Messaging SDK
    "com.amazon.device.sync"                    # Device Sync
    "com.amazon.device.sync.sdk.internal"      # Sync SDK
    "com.amazon.imp"                            # In-app Messaging Platform
    "com.amazon.advertisingidsettings"         # Advertising Settings
    
    # Amazon Services you probably don't need
    "com.amazon.tcomm"                          # Communications
    "com.amazon.tmm.tutorial"                  # Tutorials
    "com.amazon.vizzini"                        # Amazon App Store backend
)

# Aggressive packages (higher risk, but safe if you know what you're doing)
AGGRESSIVE_PACKAGES=(
    # Amazon services
    "com.amazon.webview"                        # Amazon WebView (may break some apps)
    "com.amazon.avod"                           # Amazon Video on Demand
    "com.amazon.devicesetup"                    # Device Setup
    "com.amazon.communication.discovery"        # Discovery Service
    "com.amazon.kindle.devicecontrols"         # Kindle Device Controls
    "com.amazon.cardinal"                       # Cardinal (recommendation service)
    "com.amazon.tv.parentalcontrols"           # Parental Controls (if not used)
    "com.amazon.tv.csapp"                       # Customer Service App
    "com.amazon.ftv.xpicker"                   # Content Picker
    "com.amazon.fireos.externalmediaplayer"    # External Media Player
    "com.amazon.tv.support"                     # Support App
    "com.amazon.device.bluetoothdfu"           # Bluetooth DFU
    
    # More telemetry
    "com.amazon.device.software.ota"           # OTA Updates (blocks updates!)
    "com.amazon.device.software.ota.override"  # OTA Override
    "com.amazon.metrics.api"                    # Metrics API
    "com.amazon.provider"                       # Amazon Provider
    "com.amazon.client.metrics"                 # Client Metrics
    "com.amazon.client.metrics.api"            # Metrics API
    
    # Additional bloat
    "com.amazon.tv.ime"                         # Amazon IME (input method)
    "com.amazon.kso.blackbird"                 # Blackbird Service
    "com.amazon.device.logmanager"             # Log Manager
)

# Function to disable package
disable_package() {
    local package=$1
    
    if [ "$DRY_RUN" = true ]; then
        echo -e "  ${YELLOW}[DRY RUN]${NC} Would disable: $package"
        return
    fi
    
    # Check if package exists
    if adb shell pm list packages | grep -q "^package:${package}$"; then
        # Try to disable the package
        result=$(adb shell pm disable-user --user 0 "$package" 2>&1)
        
        if echo "$result" | grep -q "new state: disabled"; then
            echo -e "  ${GREEN}✓${NC} Disabled: $package"
        elif echo "$result" | grep -q "already disabled"; then
            echo -e "  ${YELLOW}○${NC} Already disabled: $package"
        else
            echo -e "  ${RED}✗${NC} Failed to disable: $package"
        fi
    else
        echo -e "  ${YELLOW}○${NC} Not found: $package"
    fi
}

echo -e "${YELLOW}Starting debloat process...${NC}"
echo ""

# Disable safe packages
echo -e "${GREEN}Disabling safe packages...${NC}"
for package in "${SAFE_PACKAGES[@]}"; do
    disable_package "$package"
done

# Disable aggressive packages if in aggressive mode
if [ "$MODE" = "aggressive" ]; then
    echo ""
    echo -e "${YELLOW}Disabling aggressive packages...${NC}"
    for package in "${AGGRESSIVE_PACKAGES[@]}"; do
        disable_package "$package"
    done
fi

echo ""
echo -e "${GREEN}Debloat process complete!${NC}"
echo ""
echo -e "Next steps:"
echo -e "  1. Run ${YELLOW}./optimize.sh${NC} to apply performance tweaks"
echo -e "  2. Restart your Fire TV"
echo -e "  3. If you experience issues, run ${YELLOW}./restore.sh${NC} to restore packages"
echo ""

if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}This was a dry run. No changes were made.${NC}"
    echo -e "Remove --dry-run flag to apply changes."
fi
