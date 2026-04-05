+++
title = "Launchd Auto"
date = 2026-04-05T10:29:58+08:00
tags = ["launchd"]
categories = ["mac"]
draft = false
+++

Example:

Automatically renames `Jamf Connect.app` to `Jamf Connect 2.app` the **instant** it appears in `/Applications`, using macOS-native launchd with kernel-level FSEvents (WatchPaths). Zero polling, zero lag.

---

## Overview

| Trigger | Action |
|---|---|
| `Jamf Connect.app` appears in `/Applications` | ⚡ Fires **immediately** via WatchPaths |
| Mac boots / wakes from sleep | 🔄 Runs once via `RunAtLoad` |
| Every day at 12:00 noon | 🕛 Runs as final safety net |

---

## Step 1: Create the Rename Script

```bash
sudo nano /usr/local/bin/rename_jamf.sh
```

Paste the following:

```bash
#!/bin/bash

SRC="/Applications/Jamf Connect.app"
DST="/Applications/Jamf Connect 2.app"

if [ -d "$SRC" ]; then
    # Kill the app if it's running
    pkill -x "Jamf Connect" 2>/dev/null
    sleep 1

    # Remove destination if it already exists
    [ -d "$DST" ] && rm -rf "$DST"

    mv "$SRC" "$DST"
    echo "$(date): Renamed 'Jamf Connect.app' → 'Jamf Connect 2.app'" >> /var/log/rename_jamf.log
else
    echo "$(date): Source not found, skipping." >> /var/log/rename_jamf.log
fi
```

Make it executable:

```bash
sudo chmod +x /usr/local/bin/rename_jamf.sh
```

---

## Step 2: Create the launchd Plist

```bash
sudo nano /Library/LaunchDaemons/com.local.rename-jamf.plist
```

Paste the following:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>

    <key>Label</key>
    <string>com.local.rename-jamf</string>

    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>/usr/local/bin/rename_jamf.sh</string>
    </array>

    <!-- Trigger immediately when Jamf Connect.app appears -->
    <key>WatchPaths</key>
    <array>
        <string>/Applications/Jamf Connect.app</string>
    </array>

    <!-- Also run at boot as a safety net -->
    <key>RunAtLoad</key>
    <true/>

    <!-- Also run daily at 12:00 noon as a safety net -->
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>12</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>

    <key>StandardOutPath</key>
    <string>/var/log/rename_jamf.log</string>

    <key>StandardErrorPath</key>
    <string>/var/log/rename_jamf_error.log</string>

    <key>UserName</key>
    <string>root</string>

</dict>
</plist>
```

---

## Step 3: Set Permissions & Load

```bash
# Set correct ownership and permissions
sudo chown root:wheel /Library/LaunchDaemons/com.local.rename-jamf.plist
sudo chmod 644 /Library/LaunchDaemons/com.local.rename-jamf.plist

# Load the daemon
sudo launchctl load /Library/LaunchDaemons/com.local.rename-jamf.plist

# Trigger immediately to test
sudo launchctl start com.local.rename-jamf
```

---

## Step 4: Verify It Is Running

### Check it's loaded
```bash
sudo launchctl list | grep rename-jamf
```

Expected output:
```
-   0   com.local.rename-jamf
```

| Column | Value | Meaning |
|---|---|---|
| PID | `-` | Idle (normal when not actively running) |
| Exit Code | `0` | ✅ Last run succeeded |
| Exit Code | `1` | ❌ Last run failed — check error log |
| Not listed | — | ❌ Not loaded — reload it |

### Validate the plist syntax
```bash
plutil -lint /Library/LaunchDaemons/com.local.rename-jamf.plist
```
Expected: `com.local.rename-jamf.plist: OK`

### Check the plist is in place
```bash
ls -la /Library/LaunchDaemons/com.local.rename-jamf.plist
```

### Check logs
```bash
tail -20 /var/log/rename_jamf.log
tail -20 /var/log/rename_jamf_error.log
```

---

## Management Commands

| Action | Command |
|---|---|
| Load / enable | `sudo launchctl load /Library/LaunchDaemons/com.local.rename-jamf.plist` |
| Unload / disable | `sudo launchctl unload /Library/LaunchDaemons/com.local.rename-jamf.plist` |
| Reload after edits | `sudo launchctl unload ... && sudo launchctl load ...` |
| Trigger manually | `sudo launchctl start com.local.rename-jamf` |
| Check status | `sudo launchctl list \| grep rename-jamf` |
| Watch logs live | `tail -f /var/log/rename_jamf.log` |

---

## Why WatchPaths? — Performance Impact

| Method | How it works | CPU/RAM impact |
|---|---|---|
| **WatchPaths (launchd)** | Kernel FSEvents — sleeps until file event fires | ~0% — event-driven |
| `StartInterval` polling | Wakes every N seconds to check | Very low but wasteful |
| `while true; do sleep 1` loop | Constant process running | ⚠️ Unnecessary overhead |

`WatchPaths` is **completely event-driven** — the daemon is dormant until a filesystem change occurs at the watched path. It uses the same FSEvents mechanism as Spotlight and Time Machine. There is no noticeable performance impact on the Mac.

---

## Why `/Library/LaunchDaemons/`?

| Location | Runs as | When |
|---|---|---|
| `/Library/LaunchDaemons/` | **root** | At boot, before login ✅ |
| `/Library/LaunchAgents/` | root | After login |
| `~/Library/LaunchAgents/` | current user | After user login |

Renaming apps in `/Applications` requires **root privileges**, making `LaunchDaemons` the correct choice.

---

## Does It Run When the MacBook Lid Is Closed?

No — both `cron` and `launchd` are paused when the Mac is asleep. However:

- `WatchPaths` will fire **immediately on wake** if `Jamf Connect.app` appeared while asleep
- `RunAtLoad` ensures it runs on every **boot and wake**
- `StartCalendarInterval` catches up and runs on the **next wake** if the Mac was asleep at noon

This combination makes the setup resilient without needing the Mac to be awake 24/7.

---

## File Summary

| File | Purpose |
|---|---|
| `/usr/local/bin/rename_jamf.sh` | The rename script |
| `/Library/LaunchDaemons/com.local.rename-jamf.plist` | launchd daemon configuration |
| `/var/log/rename_jamf.log` | stdout log |
| `/var/log/rename_jamf_error.log` | stderr / error log |
