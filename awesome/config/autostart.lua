local awful = require("awful")

--Compositor
awful.spawn('picom --daemon')

--Touchpad gestures
awful.spawn('xinput set-prop "ELAN0791:00 04F3:30FD Touchpad" "libinput Tapping Enabled" 1')

--nm -applet
awful.spawn('nm-applet')

--nitrogen
awful.spawn('nitrogen --restore')

--lockscreen
awful.spawn.with_shell([[sleep 1s && xss-lock i3lock]])
