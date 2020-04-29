 #!/bin/bash

############################################################
#////    		 		QEMU SCRIPT			    	  /////#
############################################################

workdir="$PWD"
iso="${workdir}/archlinux-2020.04.01-x86_64.iso"
uefi="-bios /usr/share/ovmf/x64/OVMF_CODE.fd"

qemu-system-x86_64 -machine type=pc,accel=kvm -m 4G -enable-kvm -cpu host -smp cores=4 -usbdevice tablet \
${uefi} \
-drive file=/dev/sdb,if=virtio,format=raw \
-drive file=${iso},media=cdrom -boot d \
-device usb-ehci,id=ehci -device usb-host,bus=ehci.0,hostbus=7,hostaddr=7 \
-device usb-ehci,id=ehci1 -device usb-host,bus=ehci.0,vendorid=0x0bda,productid=0x8153 \
-usb -device usb-tablet \
-vga std \
-k de
