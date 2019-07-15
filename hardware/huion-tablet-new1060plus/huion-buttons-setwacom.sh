#!/bin/sh
xsetwacom set "HID 256c:006e Pad pad" button 1 key  
xsetwacom set "HID 256c:006e Pad pad" button 2 key e
xsetwacom set "HID 256c:006e Pad pad" button 3 key b
xsetwacom set "HID 256c:006e Pad pad" button 8 key +
xsetwacom set "HID 256c:006e Pad pad" button 9 key Ctrl Z
# xsetwacom set "HID 256c:006e Pad pad" button 10 key +Ctrl +shift Z -shift -Ctrl
xsetwacom set "HID 256c:006e Pad pad" button 10 key Ctrl Y
xsetwacom set "HID 256c:006e Pad pad" button 11 key Ctrl +shift + -shift
xsetwacom set "HID 256c:006e Pad pad" button 12 key Ctrl -

# xsetwacom set "HID 256c:006e Pen stylus" button 1 1
xsetwacom set "HID 256c:006e Pen stylus" PressureCurve "0 40 90 100" #Beziel Curve (4 parameters)

