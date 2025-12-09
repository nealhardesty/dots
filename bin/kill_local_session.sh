#!/bin/bash

# Only proceed if we are logging in via a remote desktop session (e.g., xrdp)
if [ ! -z "$XRDP_SESSION" ] || [ ! -z "$XDG_SESSION_TYPE" ] && [ "$XDG_SESSION_TYPE" = "xrdp" ]; then
    # Find and terminate a local Cinnamon session for the current user cleanly
    # Note: 'cinnamon-session' may not be running directly for the local console.
    # A more aggressive, but often necessary, approach is to target the process.

    # Look for the current user's *other* graphical sessions and terminate them.
    # This command finds sessions not associated with the current tty or display (i.e., the local console).
    # THIS IS AN ADVANCED COMMAND - Use with Caution!
    pids=$(pgrep -u $USER -d ' ' --full "cinnamon-session|gnome-session" | tr ' ' '\n' | while read pid; do
        if ! grep -q "display $DISPLAY" /proc/$pid/environ 2>/dev/null; then
            echo $pid
        fi
    done)

    if [ ! -z "$pids" ]; then
        echo "Terminating existing session PIDs: $pids" >> ~/xrdp_session_kill.log
        # Attempt a clean session quit first
        cinnamon-session-quit --logout --force --no-prompt 2>/dev/null
        sleep 3
        # Fallback: forcefully kill any remaining graphical session processes for the user
        kill -9 $pids 2>/dev/null
    fi
fi

