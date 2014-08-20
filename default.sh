
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
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

# Enable AirDrop over Ethernet and on unsupported Macs running Lion
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Disable disk image verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true


