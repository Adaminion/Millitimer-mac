#!/bin/bash

# This script removes the "quarantine" attribute from the Millitimer app.
# This fixes the "app is damaged and can't be opened" or "malicious software" warning
# that appears because the app is not notarized by Apple.

APP_PATH="build/macos/Build/Products/Release/millitimer.app"

if [ -d "$APP_PATH" ]; then
    echo "Removing quarantine attribute from $APP_PATH..."
    xattr -cr "$APP_PATH"
    echo "Done! You should now be able to open the app."
else
    echo "Error: App not found at $APP_PATH"
    echo "Make sure you have built the app with 'flutter build macos' first."
fi
