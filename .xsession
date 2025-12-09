#!/bin/bash

if command -v cinnamon-session >/dev/null 2>&1; then
    exec cinnamon-session
else
    exec gnome-session
fi
