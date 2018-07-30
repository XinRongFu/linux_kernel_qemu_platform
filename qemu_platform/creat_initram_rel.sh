#!/bin/bash
#20059b62-2542-4a85-80cf-41da6e0c1137
#f1a02de6-d5af-4172-899c-10b0966f1c1d
dracut --kernel-cmdline "root=UUID=f1a02de6-d5af-4172-899c-10b0966f1c1d rootflags=rw,relatime,ssd,space_cache rootfstype=ext4 systemd.unit=emergency.target" --no-hostonly --no-hostonly-cmdline --kver $1 --kmoddir /home/sean/work/source/upstream/kernel.org/initramfs/lib/modules/$1 --add-drivers "iscsi_target_mod target_core_mod target_core_file target_core_iblock configfs" --install "fdisk mount ifconfig strace" --debug -v --logfile ./dracut_ffff.txt ./initrd-$1
