#!/bin/bash
#
# ~/.xinitrc
#

# Load resources
xrdb ~/.Xresources

# Start Awesome ==================================================
feh --bg-center /home/ken/picture/mn234.jpg &
xcompmgr -c -t-5 -l-5 -r4.2 -o.55 &
~/.awesome/widgets &
trayer --edge bottom --align right --widthtype request --height 14 --SetDockType true --transparent true --alpha 255 --expand true &
volwheel &
parcellite &
numlockx on
export LC_CTYPE=zh_CN.UTF-8
export XMODIFIERS=@im=fcitx
export XIM=fcitx
export XIM_PROGRAM=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
fcitx -d &
exec awesome

# Start dwm =======================================================
#   while true
#    do
#      xsetroot -name "`date` `uptime | sed 's/.*,//'`"
#      sleep 1
#    done &
#	exec dwm

# Other wm or DE ==================================================
#	exec wmii
#   exec startxfce4
#	exec gnome-session

# Some addon-config ===============================================
# xscreensaver -no-splash &
#  
#  # if [ -x /usr/bin/nm-applet ] ; then
#  #    nm-applet --sm-disable &
#  # fi
#   
#   # if [ -x /usr/bin/gnome-power-manager ] ; then
#   #    sleep 3
#   #    gnome-power-manager
#   # fi


