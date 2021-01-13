#!/bin/sh
# This requires that the X11 server on the windows host be running with
# authentication enabled and that the windows firewall be modified to accept
# connections from the WSL2 VM.
# The required windows defender firewall rule is a TCP allow on port 6000 to
# and from `172.16.0.0/12` for the `vcxsrv.exe` process only. I believe this
# is actually the default Hyper-V vEthernet switch network range, so may vary
# depending on the local Hyper-V config. If public network access was blocked
# when vcxsrv was initially run, the TCP block rule will need to be disabled in
# windows defender firewall advanced settings as well. This is because the
# internal WSL2 network is classed as "public" and blocks take priority over
# allows.
#
# VcXsrv example startup command:
# "C:\Program Files\VcXsrv\vcxsrv.exe" -auth "C:\Users\john\.XAuthority" -dpi auto -dpms -multiwindow -nowgl
#
# Useful discussion here:
# https://stackoverflow.com/questions/61110603/how-to-set-up-working-x11-forwarding-on-wsl2

WSL_HOST="$(pwsh.exe -c 'Write-Host -NoNewline (Get-NetIPAddress -InterfaceAlias "vEthernet (WSL)" -AddressFamily IPv4).IPAddress')"
export XAUTHORITY=/mnt/c/Users/john/.Xauthority
export DISPLAY="${WSL_HOST}:0.0"
export LIBGL_ALWAYS_INDIRECT=0
export NO_AT_BRIDGE=1

if [ -z "$(xauth list "${DISPLAY}")" ]; then
  xauth add "${DISPLAY}" . "$(xxd -l 16 -p /dev/urandom)"
fi
