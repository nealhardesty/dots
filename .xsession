# Disable DPMS turning off the screen
 xset -dpms
 xset s off

 # Disable bell
 xset -b

 # Enable zapping (C-A-<Bksp> kills X)
 setxkbmap -option terminate:ctrl_alt_bksp

 # Enforce correct locales from the beginning:
 # LC_ALL is unset since it overwrites everything
 # LANG=de_DE.UTF-8 is used, except for:
 # LC_MESSAGES=C never translates program output
 # LC_TIME=en_DK leads to yyyy-mm-dd hh:mm date/time output
 unset LC_ALL
 export LANG=en_US.UTF-8
 export LC_MESSAGES=C
 export LC_TIME=en_US.UTF-8

 # Use XToolkit in java applications
 export AWT_TOOLKIT=XToolkit

 # Set background color
 xsetroot -solid "#112244"

 # Enable core dumps in case something goes wrong
 ulimit -c unlimited

xmodmap ~/.xmodmap

 # Start i3 and log to ~/.i3/logfile
 echo "Starting at $(date)" >> /var/tmp/i3logfile
 exec /usr/bin/i3 -V -d all >> /var/tmp/i3logfile
