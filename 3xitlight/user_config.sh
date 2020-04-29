#!/bin/bash

echo
echo
echo "####################################"
echo "#        Running config.sh!		 #"
echo "####################################"
echo
echo
sleep 2
 
#
gsettings set org.mate.interface gtk-theme Abrus-dark
gsettings set org.mate.interface icon-theme DarK
gsettings set org.mate.interface use-custom-font true
gsettings set org.mate.interface enable-animations false
gsettings set org.mate.interface font-name Zekton\ 13
gsettings set org.mate.interface monospace-font-name Terminess\ 13
gsettings set org.mate.interface document-font-name Zekton\ 12
gsettings set org.mate.interface background /usr/share/backgrounds/3xitlight/firered-polygons.jpg

echo
echo
echo "####################################"
echo "#        DONE config.sh!		 #"
echo "####################################"
echo
echo
sleep 3
