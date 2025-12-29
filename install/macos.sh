#!/bin/bash

# =============================================================================
# macOS Configuration Script
# Target: macOS Sequoia (15.x) and later
# Description: Keyboard speed, Caps Lock to Escape, Finder Column View, and Sidebar.
# =============================================================================

echo "Starting macOS configuration..."

# English: Ask for administrator password upfront
sudo -v

# English: Keep-alive sudo until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# -----------------------------------------------------------------------------
# 1. KEYBOARD: Repeat Rate and Delay
# -----------------------------------------------------------------------------
echo "Configuring Keyboard repeat rates..."

# English: Set a blazingly fast repeat rate (Standard minimum is 2)
defaults write NSGlobalDomain KeyRepeat -int 2

# English: Set a shorter delay until repeat starts (Standard minimum is 15)
defaults write NSGlobalDomain InitialKeyRepeat -int 15


# -----------------------------------------------------------------------------
# 2. KEYBOARD: Remap Caps Lock to Escape (via LaunchDaemon)
# -----------------------------------------------------------------------------
echo "Remapping Caps Lock to Escape using your custom plist..."

PLIST_PATH="/Library/LaunchDaemons/com.local.KeyRemapping.plist"

# English: Writing your specific plist structure to the system directory
sudo tee $PLIST_PATH > /dev/null <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.local.KeyRemapping</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/hidutil</string>
        <string>property</string>
        <string>--set</string>
        <string>{"UserKeyMapping":[
            {
              "HIDKeyboardModifierMappingSrc": 0x700000039,
              "HIDKeyboardModifierMappingDst": 0x700000029
            }
        ]}</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

# English: Set correct ownership and permissions for the Daemon
sudo chown root:wheel $PLIST_PATH
sudo chmod 644 $PLIST_PATH

# English: Load the daemon (using bootstrap for modern macOS versions)
sudo launchctl bootstrap system $PLIST_PATH 2>/dev/null || echo "Daemon already loaded or requires restart."


# -----------------------------------------------------------------------------
# 3. SPOTLIGHT: Disable Cmd+Space for Raycast/Alfred
# -----------------------------------------------------------------------------
echo "Disabling native Spotlight shortcut (Cmd+Space)..."

# English: 64 is the ID for the main Spotlight search window
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:64:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist


# -----------------------------------------------------------------------------
# 4. FINDER: Column View and Sidebar
# -----------------------------------------------------------------------------
echo "Configuring Finder (Column view, Sidebar Home)..."

# English: Set default view to Column View
defaults write com.apple.Finder FXPreferredViewStyle -string "clmv"

# English: Folders first
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# English: Show Path bar and Status bar
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# -----------------------------------------------------------------------------
# 5. RESTART SERVICES
# -----------------------------------------------------------------------------
echo "Restarting Finder and SystemUIServer..."

killall Finder
killall SystemUIServer

echo "Done! Note: You may need to logout and log back in for all changes to take full effect."
