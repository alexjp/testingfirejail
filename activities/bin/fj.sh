#!/usr/bin/dash

BIN="$(basename $0)"
ACTIVITY=$(qdbus org.kde.ActivityManager /ActivityManager/Activities CurrentActivity)
BASEFOLDER="$HOME/activities"
DIRECTORY="$BASEFOLDER/$ACTIVITY"


# Copy base skel settings
if [ ! -d "$DIRECTORY" ] || [ "$BIN" = "firejail.dosync" ]; then
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


  if [ "$BIN" = "firejail.dosync" ]; then
    echo sync settings
    notify-send "sync settings: done"
    exit 0
  fi
fi


# If the command was called without arguments
if [ $BIN = "fj.sh" ] ; then
  #firejail --profile=/home/alex/.config/firejail/custom.profile --private="$DIRECTORY" --join-or-start="$ACTIVITY" 
  firejail --noprofile --private="$DIRECTORY" --join-or-start="$ACTIVITY" 
  exit 0
fi

# If the file starting with a dot and the name of the activity exists, no firejail
if [ -e "$BASEFOLDER/.$ACTIVITY" ]; then
  exec $(which "$BIN" -a | head -n2 | tail -n1) "$@"
  exit 0
fi



#firejail --profile=/home/alex/.config/firejail/custom.profile --private="$DIRECTORY" --join-or-start="$ACTIVITY" "$BIN" $@ 
#firejail --noprofile --private="$DIRECTORY" --join-or-start="$ACTIVITY" --dbus-user=filter --dbus-user.talk="org.freedesktop.portal.Desktop" "$BIN" $@ 
firejail --noprofile --private="$DIRECTORY" --join-or-start="$ACTIVITY" "$BIN" $@ 
