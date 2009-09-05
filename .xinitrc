#!/bin/bash
#
# .xsession/.xinitrc
#
# choose a window manager
#
# 这里可以设置一些环境变量：

xrdb /home/ken/.Xresources
feh --bg-center /home/ken/picture/arch.png
numlockx &
export LANG=zh_CN.UTF-8
export LC_CTYPE=zh_CN.UTF-8
export XMODIFIERS="@im=fcitx"
export XIM=fcitx
export XIM_PROGRAM=fcitx
export GTK_IM_MODULE=xim
export QT_IM_MODULE=fcitx

defaultwm=xmonad  # 指定如果没有提供启动 wm 参数，默认为启动 KDE。
windowmgr=${1:-$defaultwm}
#根据参数不同启动不同的 wm
case ${windowmgr} in
xmonad)
WINDOWMANAGER=xmonad
exec xcompmgr -cC -t-5 -l-5 -r4.2 -o.55 &
exec fcitx &
;;
awesome)
WINDOWMANAGER=awesome
exec xcompmgr -cC -t-5 -l-5 -r4.2 -o.55 &
exec /home/ken/.awesome/widgets &
exec trayer --edge bottom --align right --widthtype request --height 14 --expand true --transparent true --alpha 0 --tint 0x252525 --padding 5 &
exec volwheel &  # 这里我加入了两个程序随 fluxbox 启动
exec parcellite &
exec fcitx &
;;
gnome)
WINDOWMANAGER=gnome-session
;;
xfce4|xfce)
WINDOWMANAGER=startxfce4
;;
*) WINDOWMANAGER=windowmgr
esac

exec $WINDOWMANAGER
