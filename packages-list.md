# Fire TV Package Reference

Complete list of packages that can be safely disabled on Amazon Fire TV devices.

## 🟢 Safe to Remove (Low Risk)

These packages can be disabled with minimal risk. Most users won't need these services.

### Amazon Shopping & Services
| Package Name | Description | Impact if Disabled |
|-------------|-------------|-------------------|
| `com.amazon.shoptv.client` | Amazon Shop TV | Can't browse Amazon store from TV |
| `com.amazon.venezia` | Amazon App Store | Can't download apps (use sideloading) |
| `com.amazon.kindle.otter` | Kindle app | Can't read Kindle books |
| `com.amazon.ods.kindleconnect` | Kindle connectivity | Kindle sync disabled |
| `com.amazon.hedwig` | Goodreads | Can't use Goodreads integration |
| `com.audible.application.kindle` | Audible app | Can't listen to audiobooks |

### Media Apps (if not used)
| Package Name | Description | Impact if Disabled |
|-------------|-------------|-------------------|
| `com.amazon.tahoe` | Amazon Prime Video | Can't watch Prime Video |
| `com.amazon.music.tv` | Amazon Music | Can't use Amazon Music |
| `com.amazon.photos.importer` | Amazon Photos | Can't view/import photos |
| `com.amazon.clouddrive.photos` | Amazon Photos cloud | Photo sync disabled |
| `com.amazon.avod` | Amazon Video on Demand | VOD services unavailable |

### Alexa & Voice Features
| Package Name | Description | Impact if Disabled |
|-------------|-------------|-------------------|
| `amazon.alexa.tablet` | Alexa app | Voice features limited |
| `com.amazon.alexa.voice.layer` | Alexa voice layer | Voice commands may fail |
| `com.amazon.ftv.alexa.activation` | Alexa activation | Voice activation disabled |

### Tips & Tutorials
| Package Name | Description | Impact if Disabled |
|-------------|-------------|-------------------|
| `com.amazon.tmm.tutorial` | Tips & tutorials | No onboarding tips |
| `com.amazon.tv.csapp` | Customer Service | Can't access built-in support |

### Advertising & Tracking
| Package Name | Description | Impact if Disabled |
|-------------|-------------|-------------------|
| `com.amazon.advertisingidsettings` | Advertising ID | Less targeted ads |
| `com.amazon.imp` | In-app messaging | No promotional messages |
| `com.amazon.device.messaging` | Device messaging | Push notifications affected |
| `com.amazon.device.messaging.sdk.internal.library` | Messaging SDK | Background for above |
| `com.amazon.ags.app` | Amazon Game Service | Game features may break |

### Sync & Cloud Services
| Package Name | Description | Impact if Disabled |
|-------------|-------------|-------------------|
| `com.amazon.device.sync` | Device sync | Settings won't sync |
| `com.amazon.device.sync.sdk.internal` | Sync SDK | Background for above |
| `com.amazon.tcomm` | Communications | Messaging features disabled |

### Social Media Integration
| Package Name | Description | Impact if Disabled |
|-------------|-------------|-------------------|
| `com.amazon.dp.fbappsandservices` | Facebook services | No Facebook integration |

### Other Services
| Package Name | Description | Impact if Disabled |
|-------------|-------------|-------------------|
| `com.amazon.ftv.glorialist` | Watchlist | Can't use watchlist feature |
| `com.amazon.vizzini` | App Store backend | May affect app downloads |
| `com.amazon.cardinal` | Recommendations | Less personalized recommendations |

## 🟡 Moderate Risk

These packages are more integrated into the system. Disable only if you understand the implications.

### System Services
| Package Name | Description | Impact if Disabled |
|-------------|-------------|-------------------|
| `com.amazon.webview` | Amazon WebView | Some apps may not render properly |
| `com.amazon.devicesetup` | Device setup | Can't run setup wizard again |
| `com.amazon.communication.discovery` | Discovery service | Device discovery affected |
| `com.amazon.ftv.xpicker` | Content picker | Content selection UI affected |
| `com.amazon.fireos.externalmediaplayer` | External media player | External media apps affected |

### Input & Display
| Package Name | Description | Impact if Disabled |
|-------------|-------------|-------------------|
| `com.amazon.tv.ime` | Amazon keyboard | Need alternative keyboard |
| `com.amazon.tv.parentalcontrols` | Parental controls | Can't set parental controls |

### Background Services
| Package Name | Description | Impact if Disabled |
|-------------|-------------|-------------------|
| `com.amazon.kso.blackbird` | Background service | Unknown effects |
| `com.amazon.device.logmanager` | Log manager | Affects logging only |
| `com.amazon.metrics.api` | Metrics API | Telemetry disabled |
| `com.amazon.client.metrics` | Client metrics | Telemetry disabled |
| `com.amazon.client.metrics.api` | Metrics API | Telemetry disabled |
| `com.amazon.provider` | Amazon provider | May affect system integration |

### Connectivity
| Package Name | Description | Impact if Disabled |
|-------------|-------------|-------------------|
| `com.amazon.device.bluetoothdfu` | Bluetooth updates | Can't update Bluetooth firmware |
| `com.amazon.kindle.devicecontrols` | Device controls | Remote control features affected |

## 🔴 High Risk / Do NOT Disable

**DO NOT DISABLE THESE** unless you know exactly what you're doing and have a way to factory reset.

| Package Name | Description | Why Keep It |
|-------------|-------------|-------------|
| `com.amazon.tv.launcher` | Fire TV Launcher | Main UI - disabling bricks device |
| `com.amazon.tv.settings` | Settings app | Can't access settings |
| `com.amazon.device.software.ota` | System updates | Security updates won't install |
| `com.amazon.tv.forcedotaupdater.v2` | Forced updater | Critical system updates |
| `com.amazon.platform` | Amazon platform services | Core system functionality |
| `com.amazon.connectivity.logic` | Network connectivity | WiFi/network may break |
| `com.amazon.kindleautomatictimezone` | Timezone services | Wrong time/timezone |
| `com.amazon.ssm` | System manager | Core system functionality |
| `com.amazon.device.controllermanager` | Controller manager | Remote won't work |
| `com.amazon.device.software.ods` | Device software | Core system component |

## Package Categories Explained

### What is safe to remove?
- **Third-party apps you don't use** (Goodreads, Audible, Kindle)
- **Amazon shopping features** (Shop TV, Store apps)
- **Advertising and telemetry services**
- **Cloud sync services you don't need**

### What should you be careful with?
- **System services** - May break app functionality
- **Input methods** - Need alternatives
- **Update services** - Blocks security updates

### What should NEVER be removed?
- **Launcher and Settings** - Core UI
- **Platform services** - Core functionality
- **Controller/connectivity** - Device becomes unusable

## How to Identify Unknown Packages

If you find a package not listed here:

1. **Check if it's running:**
   ```bash
   adb shell dumpsys package <package.name> | grep "running"
   ```

2. **Check permissions:**
   ```bash
   adb shell dumpsys package <package.name> | grep "permission"
   ```

3. **Google it:** Search for "Fire TV [package name]"

4. **Check XDA Forums:** [Fire TV section](https://forum.xda-developers.com/c/amazon-fire-tv.4999/)

5. **Test carefully:** 
   - Disable one package at a time
   - Test your device for 24 hours
   - Use `restore.sh` if issues occur

## Recommended Debloat Levels

### Conservative (Safest)
Only remove:
- Amazon shopping apps
- Goodreads, Audible, Kindle
- Advertising services
- Photos and Music (if not used)

**Expected improvement:** 10-15% performance, slightly faster UI

### Moderate (Recommended)
Conservative +
- Device sync services
- Messaging platforms
- Telemetry services
- Tutorials and tips

**Expected improvement:** 20-30% performance, noticeably faster

### Aggressive (Advanced Users)
Moderate +
- Amazon WebView
- Some background services
- Additional telemetry
- External media player

**Expected improvement:** 30-40% performance, significantly faster

### Extreme (Experts Only)
Aggressive +
- OTA updates (blocks all updates!)
- More system services
- Custom launcher required

**Expected improvement:** 40%+ performance, but higher risk of instability

## Signs You've Removed Too Much

- Remote control not responding
- Can't access settings
- Apps crashing on launch
- WiFi/network not working
- Screen freezing
- Can't navigate UI

**Solution:** Run `./restore.sh` immediately or factory reset

## Factory Reset Instructions

If your Fire TV becomes unstable:

1. **From Settings:**
   - Settings → My Fire TV → Reset to Factory Defaults

2. **Using Remote:**
   - Hold Back + Right navigation for 10 seconds

3. **Using ADB:**
   ```bash
   adb shell recovery --wipe_data
   ```

## Additional Resources

- [AFTVnews Debloat Guide](https://www.aftvnews.com/)
- [XDA Fire TV Forums](https://forum.xda-developers.com/c/amazon-fire-tv.4999/)
- [Fire TV Toolbox](https://github.com/joe-sydell/Fire-TV-Toolbox)

## Contributing

Found a package not listed? Submit a PR with:
- Package name
- Description of what it does
- Risk level (safe/moderate/high)
- What breaks if disabled
