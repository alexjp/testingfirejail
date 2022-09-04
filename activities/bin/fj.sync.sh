#!/usr/bin/env bash

BIN="$(basename $0)"
ACTIVITY=$(qdbus org.kde.ActivityManager /ActivityManager/Activities CurrentActivity)
BASEFOLDER="$HOME/.local/share/kactivitymanagerd/activities"
DIRECTORY="$BASEFOLDER/$ACTIVITY"
UPDATE=false

if [ $BIN = "fj.forcesync.sh" ]; then
  UPDATE=true
fi

if [ $# -gt 0 ]; then
  if [ $1 = "force" ]; then
      UPDATE=true
    else
      DIRECTORY="$1"
  fi

  if [ $# -gt 1 ]; then
    if [ $2 = "force" ]; then
      UPDATE=true
    fi
  fi

fi


echo $DIRECTORY
# Copy base skel settings
if [ ! -d "$DIRECTORY" ] || [ $UPDATE = "true" ]; then
  mkdir -p "$DIRECTORY"
  mkdir -p "$DIRECTORY/.config"
  mkdir -p "$DIRECTORY/.local/share"
  mkdir -p "$DIRECTORY/bin"

  cp -aL ~/.config/kdeglobals "$DIRECTORY"/.config
  cp -aL ~/.config/breezerc "$DIRECTORY"/.config

  cp -aL ~/.config/fontconfig "$DIRECTORY"/.config
  cp -aL ~/.config/gtk* "$DIRECTORY"/.config
  cp -aL ~/.config/dconf* "$DIRECTORY"/.config

  cp -aL ~/.config/konsolerc "$DIRECTORY"/.config
  cp -aL ~/.local/share/konsole "$DIRECTORY"/.local/share
 
  mkdir -p "$DIRECTORY/.local/share/dolphin"
  cp -aL ~/.config/dolphinrc "$DIRECTORY"/.config
  cp -aL ~/.local/share/dolphin/dolphinstaterc "$DIRECTORY"/.local/share/dolphin

  cp -aL ~/.local/share/color-schemes "$DIRECTORY"/.local/share

  cp -aL ~/.local/bin/firefox.sh "$DIRECTORY"/bin/firefox
  cp -aL ~/.local/bin/chromium.sh "$DIRECTORY"/bin/chromium
  cp -aL ~/.local/bin/qutebrowser.sh "$DIRECTORY"/bin/qutebrowser

  mkdir -p "$DIRECTORY"/.config/media-downloader
  cp -aL ~/.config/media-downloader/media-downloader.conf "$DIRECTORY"/.config/media-downloader
  mkdir -p "$DIRECTORY"/.local/share/media-downloader/data
  cp -aL ~/.local/share/media-downloader/data/{downloadDefaultOptions,presetOptions}.json "$DIRECTORY"/.local/share/media-downloader/data


  mkdir -p "$DIRECTORY"/.mozilla/firefox/chrome
  cp -aL ~/.local/src/firefox-gnome-theme/configuration/user.js "$DIRECTORY"/.mozilla/firefox
  cp -aL ~/.local/src/firefox-gnome-theme/userChrome.css "$DIRECTORY"/.mozilla/firefox/chrome
  cp -aL ~/.local/src/firefox-gnome-theme/userContent.css "$DIRECTORY"/.mozilla/firefox/chrome
  cp -aL ~/.local/src/firefox-gnome-theme/customChrome.css "$DIRECTORY"/.mozilla/firefox/chrome
  cp -aL ~/.local/src/firefox-gnome-theme/theme "$DIRECTORY"/.mozilla/firefox/chrome

  mkdir -p "$DIRECTORY"/.config/qutebrowser
  #mkdir -p "$DIRECTORY"/.config/qutebrowser/data
  mkdir -p "$DIRECTORY"/.local/share/qutebrowser
  cp -aL ~/.qute/activity_files/autoconfig.yml "$DIRECTORY"/.config/qutebrowser
  cp -aL ~/.qute/activity_files/config.py "$DIRECTORY"/.config/qutebrowser
  #cp -aL ~/.qute/profiles/default/data/adblock-cache.dat "$DIRECTORY"/.config/qutebrowser/data
  cp -aL ~/.local/share/qutebrowser/qtwebengine_dictionaries "$DIRECTORY"/.local/share/qutebrowser

  if [ -d "$DIRECTORY"/.config/chromium ]; then
    if [ -d "$DIRECTORY"/.config/backup.chromium ]; then
        rm -rf "$DIRECTORY"/.config/backup.chromium 
    fi
    mv "$DIRECTORY"/.config/chromium "$DIRECTORY"/.config/backup.chromium
    #mkdir -p "$DIRECTORY"/.config/chromium
  fi
  cp -aL ~/.config/chromium.export "$DIRECTORY"/.config/chromium

 
  echo sync settings
  notify-send "sync settings: done"
fi

exit 0
