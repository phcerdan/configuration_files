#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar
# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit

screens=$(xrandr --listactivemonitors | grep -v "Monitors" | cut -d" " -f6)

if [[ $(xrandr --listactivemonitors | grep -v "Monitors" | cut -d" " -f4 | cut -d"+" -f2- | uniq | wc -l) == 1 ]]; then
  MONITOR=$(polybar --list-monitors | cut -d":" -f1) TRAY_POS=right polybar main &
else
  primary=$(xrandr --query | grep primary | cut -d" " -f1)

  for m in $screens; do
    if [[ $primary == $m ]]; then
        MONITOR=$m TRAY_POS=right polybar main 2>&1 | tee -a /tmp/polybar.log & disown
    else
        MONITOR=$m TRAY_POS=none polybar secondary 2>&1 | tee -a /tmp/polybar$m.log & disown
    fi
  done
fi
