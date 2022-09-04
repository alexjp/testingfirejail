#!/usr/bin/dash

BIN="$(basename $0)"
ACTIVITY=$(qdbus org.kde.ActivityManager /ActivityManager/Activities CurrentActivity)
BASEFOLDER="/home/alex/.local/share/kactivitymanagerd/activities"
BASEFOLDERBIN="$BASEFOLDER/bin"
DIRECTORY="$BASEFOLDER/$ACTIVITY"

if [ ! -d "$DIRECTORY" ]; then
  /home/alex/.local/bin/fj.sync.sh "$DIRECTORY"
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
#firejail --noprofile --private="$DIRECTORY" \
#  --dbus-user=filter \
#  --dbus-user.talk="org.freedesktop.*" \
#  --dbus-user.talk="org.kde.*" \
#  --dbus-user.talk="org.pulseaudio.*" \
#  --join-or-start="$ACTIVITY" \
#  "$BIN" $@ 
#  
  #--dbus-user.own="org.kde.*" \
  #--dbus-user.own="org.mozilla.*" \

#firejail --noprofile --private="$DIRECTORY" --join-or-start="$ACTIVITY" "$BIN" $@ 
BINPATH=$(which "$BIN" -a | grep -v $BASEFOLDERBIN | head -n1)

#echo env HOME="$DIRECTORY" $BINPATH $@
systemd-run --user -p StateDirectory="$ACTIVITY" -p Environment=HOME="$DIRECTORY" -p WorkingDirectory="$DIRECTORY" -t "$BINPATH" $@
