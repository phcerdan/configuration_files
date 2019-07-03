Not compatible with Wayland, remove the default wayland in gdm
In: /etc/gdm/custom.conf
WaylandEnable=false

The .conf file goes to:
/etc/X11/xorg.conf.d/50-tablet-huion.conf

This will use wacom driver, even when the tablet is not wacom

To use setwacom, install the x11 wacom package:
sudo pacman -S xf86-input-wacom
The graphical interface won't work, so we use setwacom directly

Keys defined in: huion-buttons-setwacom.sh
Reference: https://github.com/DIGImend/digimend-kernel-drivers/issues/26


