#!/usr/bin/env bash
set -e

REBOOT='true'

function end() {
   if [ "$REBOOT" == 'true' ]; then
        echo ""
        echo -e "${GREEN}Arch Linux installed successfully"'!'"${NC}"
        umount -R #/mnt/boot
        umount -R #/mnt
        sync
        sleep 1
        reboot
   fi
    
   echo ""
   echo -e "${GREEN}Arch Linux installed successfully"'!'"${NC}"
    
}

end
