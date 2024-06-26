#!/bin/sh
test $(id -u) -eq 0 || { echo "Please call this script with sudo" >&2; exit 1; }
systemctl stop run-vmblock\\x2dfuse.mount
killall -q -w vmtoolsd
systemctl start run-vmblock\\x2dfuse.mount
systemctl enable run-vmblock\\x2dfuse.mount
vmware-user-suid-wrapper vmtoolsd -n vmusr 2>/dev/null
vmtoolsd -b /var/run/vmroot 2>/dev/null
