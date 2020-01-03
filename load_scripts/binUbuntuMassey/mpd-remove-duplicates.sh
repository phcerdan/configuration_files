#!/bin/sh
# Remove duplicates from MPD playlist.
# Export MPD_HOST and MPD_PORT if you want to connect to a different host.
mpc playlist -f '%position%\t%file%' | sort -k 2 | perl -ne 'm/(.*)\t(.*)/; print "$1\n" if $2 eq $prev; $prev=$2' | mpc del