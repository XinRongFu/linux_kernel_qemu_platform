#!/bin/bash
# -drive file=/dev/sdb3,media=disk -drive file=/dev/sdc1,media=disk
# ./qemu_platform/hda.img
IF_NAME=`brctl show | awk '{if($1 == "br0") print $1}'`
echo bridge: $IF_NAME
if [ -z $IF_NAME ]; then
	echo "Create br0"
	brctl addbr br0
	ifconfig br0 up
	brctl addif br0 eth0
	dhclient br0 -v
fi

qemu-kvm -D /tmp/qemu-kvm-machine.log -m 1024M -append "root=UUID=f1a02de6-d5af-4172-899c-10b0966f1c1d rootflags=rw rootfstype=ext4 debug debug_objects console=ttyS0,115200n8 rd.debug log_buf_len=1M rd.shell kmemleak=on $*" -kernel ./qemu_platform/bzImage -hda /home/sean/sda5/image/hda_10g.img -initrd ./qemu_platform/initrd-$1 -netdev tap,id=network0 -device e1000,netdev=network0,id=net0 -netdev tap,id=network1 -device e1000,netdev=network1,id=net1 -drive file=/home/sean/sda5/image/hd_2G.disk -drive file=/home/sean/sda5/image/data_10.5m.img,media=disk -chardev serial,id=ttyS0,path=/dev/ttyS0 -chardev pty,id=tty2 -chardev tty,id=tty1,path=/dev/tty1 -serial pty -display vnc=*:0 -monitor stdio -s 
