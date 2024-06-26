#!/bin/sh
test $(id -u) -eq 0 || { echo "Please call this script with sudo" >&2; exit 1; }
vmware-hgfsclient | while read folder; do
  vmwpath="/mnt/hgfs/${folder}"
  echo "[i] Mounting ${folder}   (${vmwpath})"
  mkdir -p "${vmwpath}"
  umount -f "${vmwpath}" 2>/dev/null
  vmhgfs-fuse -o allow_other -o auto_unmount ".host:/${folder}" "${vmwpath}"
done
sleep 2s
