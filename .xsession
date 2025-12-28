#!/bin/bash

if command -v startxfce4 >/dev/null 2>&1; then
  # Use XFCE for remote sessions
  export GNOME_SHELL_SESSION_MODE=ubuntu
  export XDG_CURRENT_DESKTOP=XFCE
  exec /usr/bin/startxfce4
elif command -v cinnamon-session >/dev/null 2>&1; then
  exec cinnamon-session
else
  exec gnome-session
fi
