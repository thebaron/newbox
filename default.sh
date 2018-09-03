
# save panel expanded
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true && \
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true && \
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true


# expand print panel
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true && \
defaults write -g PMPrintingExpandedStateForPrint -bool true && \
defaults write -g PMPrintingExpandedStateForPrint2 -bool true

defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false && \
defaults write -g NSDocumentSaveNewDocumentsToCloud -bool false

defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
defaults write com.apple.helpviewer DevMode -bool true
defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144

# Follow the keyboard focus while zoomed in
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true
defaults write com.twitter.twitter-mac HideInBackground -bool true

# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

# Enable AirDrop over Ethernet and on unsupported Macs
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true
defaults remove com.apple.NetworkBrowser DisableAirDrop

# Disable disk image verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# enable develop menu and web inspector in safari
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true && \
defaults write com.apple.Safari IncludeDevelopMenu -bool true && \
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true && \
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true && \
defaults write -g WebKitDeveloperExtras -bool true

# disable the horrid backspace == back 
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool NO

# focus follows mouse in apple terminal
defaults write com.apple.Terminal FocusFollowsMouse -string YES

# ditch that fucking dock
defaults write com.apple.dock autohide-delay -float 1000 && \
defaults write com.apple.dock autohide -bool true && \
defaults write com.apple.dock launchanim -bool false && \
defaults write com.apple.dock no-bouncing -bool true && \
killall Dock

# Some finder settings - deskotp icons, window settings
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true && \
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true && \
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true && \
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true && \
defaults write com.apple.finder QuitMenuItem -bool true && \
defaults write com.apple.finder ShowPathbar -bool true && \
defaults write com.apple.finder ShowStatusBar -bool true && \
defaults write com.apple.finder NewWindowTarget -string "PfLo" && \
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}" && \
killall Finder

# My mac is not an iphone:
# no power chime
defaults write com.apple.PowerChime ChimeOnAllHardware -bool false && \
killall PowerChime
# autocorrect bullshit OFF
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
# notification center OFF
launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist && \
killall -9 NotificationCenter

# keyboard settings
defaults write -g InitialKeyRepeat -int 2

# remote login allowed
sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist

# screensaver security
defaults write com.apple.screensaver askForPasswordDelay -int 0
defaults write com.apple.screensaver askForPassword -int 1

