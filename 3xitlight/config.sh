#!/bin/bash

echo
echo
echo "####################################"
echo "#        Running config.sh!		 #"
echo "####################################"
echo
echo

export XDIR="/usr/share/3xitlight"


######################################################################################################
cp -f ${XDIR}/org.mate.interface.gschema.xml /usr/share/glib-2.0/schemas/
cp -f ${XDIR}/lightdm.conf /etc/lightdm/
cp -f ${XDIR}/lightdm-gtk-greeter.conf /etc/lightdm/
cp -f ${XDIR}/users.conf /etc/lightdm/users.conf
cp -f ${XDIR}/ssh_config /etc/ssh/
cp -f ${XDIR}/sshd_config /etc/
cp -f ${XDIR}/ufw /etc/default/ufw/ufw
mkdir -f /usr/share/backgrounds/3xitlight
cp -r ${XDIR}/Wallpaper/* /usr/share/backgrounds/3xitlight

#######################
chmod 644 ${XDIR}/bashrc
chmod 644 ${XDIR}/providers.conf
chown xnn:xnn ${XDIR}/bashrc
chown xnn:xnn ${XDIR}/providers.conf
cp -f ${XDIR}/bashrc /home/xnn/.bashrc
mkdir -p /home/xnn/.config/Qtwebflix/
cp -f ${XDIR}/providers.conf /home/xnn/.config/Qtwebflix/

######################
chmod +x /usr/share/3xitlight/ufw.sh
/usr/share/3xitlight/ufw.sh
glib-compile-schemas /usr/share/glib-2.0/schemas/

#####################################################
gsettings set org.mate.interface gtk-theme Abrus-dark
gsettings set org.mate.interface icon-theme DarK
gsettings set org.mate.interface use-custom-font true
gsettings set org.mate.interface enable-animations false
gsettings set org.mate.interface font-name Zekton\ 13
gsettings set org.mate.interface monospace-font-name Terminess\ 13
gsettings set org.mate.interface document-font-name Zekton\ 12
gsettings set org.mate.interface background /usr/share/backgrounds/3xitlight/firered-polygons.jpg

########################
systemctl enable lightdm
systemctl enable --now ufw
systemctl enable --now apparmor
systemctl disable --now avahi-daemon


echo
echo
echo "####################################"
echo "#        DONE config.sh!		 #"
echo "####################################"
echo
echo
sleep 3
