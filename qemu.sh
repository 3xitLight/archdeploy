 #!/bin/bash

############################################################
#////    		 		QEMU SCRIPT			    	  /////#
############################################################

workdir="$PWD"
iso="${workdir}/archlinux-2020.04.01-x86_64.iso"
uefi="-bios /usr/share/ovmf/x64/OVMF_CODE.fd"

qemu-system-x86_64 -machine type=pc,accel=kvm -m 4G -enable-kvm -cpu host -smp cores=4 -usbdevice tablet \
${uefi} \
-device qemu-xhci,id=xhci -device usb-host,bus=xhci.0,vendorid=0x2357,productid=0x010d \
-device qemu-xhci,id=xhci1 -device usb-host,bus=xhci.0,vendorid=0x0bda,productid=0x8153 \
-drive file=/dev/sdb,format=raw  \
-drive file=${iso},media=cdrom -boot d \
-usb -device usb-tablet \
-vga std \
-k de

# ,format=raw 
# -net nic -net bridge,br=bridge0  \
# -device usb-ehci,id=ehci2 -device usb-host,bus=ehci.0,vendorid=0x0bda,productid=0x8153 \
#-device usb-ehci,id=ehci1 -device usb-host,bus=ehci.0,vendorid=0x2357,productid=0x010d \
#-device usb-ehci,id=ehci2 -device usb-host,bus=ehci.0,hostbus=2,hostaddr=6 \
#-device usb-ehci,id=ehci3 -device usb-host,bus=ehci.0,vendorid=0x2357,productid=0x010d \
# 002 Device 004: ID 2357:010d
# -device usb-ehci,id=ehci1 -device usb-host,bus=ehci.0,vendorid=0x2357,productid=0x010d \
# -device usb-ehci,id=ehci -device usb-host,bus=ehci.0,hostbus=7,hostaddr=1 \
Bus 007 Device 005: ID 2357:010d TP-Link 
