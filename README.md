# Amazon Fire TV Debloating & Optimization Toolkit

A comprehensive toolkit for removing bloatware and improving performance on Amazon Fire TV devices.

## ⚠️ Important Disclaimer

**USE AT YOUR OWN RISK.** Removing system apps may cause instability. Always research each package before removing it. This toolkit disables apps rather than completely uninstalling them, making it reversible.

## Prerequisites

1. **ADB (Android Debug Bridge)** installed on your computer
   - Windows: Download from [Android SDK Platform Tools](https://developer.android.com/studio/releases/platform-tools)
   - Mac: `brew install android-platform-tools`
   - Linux: `sudo apt install adb` or `sudo yum install android-tools`

2. **Enable ADB Debugging on Fire TV:**
   - Go to Settings → My Fire TV → About
   - Click on your Fire TV name 7 times to enable Developer Options
   - Go to Settings → My Fire TV → Developer Options
   - Turn ON "ADB Debugging" and "Apps from Unknown Sources"

3. **Find your Fire TV's IP address:**
   - Settings → My Fire TV → About → Network

## Quick Start

### 1. Connect via ADB

```bash
# Connect to your Fire TV (replace with your IP)
adb connect 192.168.1.XXX:5555

# Verify connection
adb devices
```

### 2. Run the debloat script

```bash
# Make the script executable
chmod +x debloat.sh

# Run the aggressive debloat
./debloat.sh --aggressive

# Or run the safe debloat (recommended for first-time users)
./debloat.sh --safe
```

### 3. Run performance optimizations

```bash
chmod +x optimize.sh
./optimize.sh
```

## What Gets Removed/Disabled

### Safe Mode (Recommended)
- Amazon advertising services
- Amazon shopping apps
- Amazon Photos and Music (if you don't use them)
- Goodreads
- Audible
- Amazon Silk Browser (alternative browsers available)
- Alexa shopping features
- Various telemetry and analytics services

### Aggressive Mode
- All of the above, plus:
- Additional Amazon services
- More system apps that can be replaced
- Additional telemetry

See `packages-list.md` for a complete list with descriptions.

## Scripts Included

- `debloat.sh` - Main debloating script with safe/aggressive modes
- `optimize.sh` - Performance optimization tweaks
- `restore.sh` - Restore disabled packages
- `backup.sh` - Backup current package state
- `check-status.sh` - Check which packages are disabled

## Manual Commands

### Disable a single package
```bash
adb shell pm disable-user --user 0 com.amazon.package.name
```

### Re-enable a package
```bash
adb shell pm enable --user 0 com.amazon.package.name
```

### List all packages
```bash
adb shell pm list packages
```

## Performance Tips

1. **Clear cache regularly** - Settings → Applications → Manage Installed Applications
2. **Limit background processes** - Done automatically by optimize.sh
3. **Use a launcher replacement** - Consider installing Launcher Hijack or Wolf Launcher
4. **Disable animations** - Done automatically by optimize.sh
5. **Restart regularly** - After debloating, restart your Fire TV

## Troubleshooting

### Can't connect via ADB
- Ensure both devices are on the same network
- Try disabling and re-enabling ADB on Fire TV
- Check firewall settings on your computer

### Fire TV becomes unstable
- Run `./restore.sh` to restore all packages
- Factory reset: Settings → My Fire TV → Reset to Factory Defaults

### Commands not working
- Ensure ADB connection is active: `adb devices`
- Try reconnecting: `adb disconnect` then `adb connect IP:5555`

## Additional Resources

- [XDA Fire TV Forums](https://forum.xda-developers.com/c/amazon-fire-tv.4999/)
- [AFTVnews.com](https://www.aftvnews.com/)
- Package lists and community recommendations

## Contributing

Feel free to submit pull requests with additional safe packages to remove or performance optimizations.

## License

MIT License - See LICENSE file for details
