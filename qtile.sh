#!/bin/bash -x

pip install xcfflib
pip install qtile

sudo rm -rf /usr/share/xsessions/qtile_gnome.desktop
sudo tee /usr/share/xsessions/qtile_gnome.desktop << EOF
[Desktop Entry]
Name=Qtile GNOME
Comment=Tiling window manager
TryExec=/usr/bin/gnome-session
Exec=gnome-session --session=qtile
Type=XSession
EOF

sudo rm -rf /usr/share/gnome-session/sessions/qtile.session
sudo tee /usr/share/gnome-session/sessions/qtile.session << EOF
[Desktop Entry]
Name=Qtile GNOME
Comment=Tiling window manager
TryExec=/usr/bin/gnome-session
Exec=gnome-session --session=qtile
Type=XSession
EOF

sudo rm -rf /usr/share/applications/qtile.desktop 
sudo tee /usr/share/applications/qtile.desktop << EOF
[Desktop Entry]
Type=Application
Encoding=UTF-8
Name=Qtile
Exec=qtile start
NoDisplay=true
X-GNOME-WMName=Qtile
X-GNOME-Autostart-Phase=WindowManager
X-GNOME-Provides=windowmanager
X-GNOME-Autostart-Notify=false
EOF
