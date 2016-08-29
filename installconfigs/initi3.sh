#!/bin/bash

echo <<EOF
new_window none
hide_edge_borders both

bindsym $mod+Shift+e exec ~/.config/i3/exit_menu.sh
bindsym $mod+Shift+d exec pcmanfm
bindsym $mod+Shift+w exec google-chrome-stable
bindsym $mod+Shift+s exec subl3
bindsym $mod+Shift+l exec slock
bindsym Print exec scrot
EOF >> ~/.config/i3/config

cp /etc/installconfigs/exit_menu.sh ~/.config/i3/exit_menu.sh
chmod +x ~/.config/i3/exit_menu.sh