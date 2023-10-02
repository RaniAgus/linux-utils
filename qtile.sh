#!/bin/bash -x

pip install xcfflib
pip install qtile

sudo tee /usr/share/xsessions/qtile.desktop << EOF
[Desktop Entry]
Name=Qtile
Comment=Qtile Session
Exec=qtile start
Type=Application
Keywords=wm;tiling
EOF
