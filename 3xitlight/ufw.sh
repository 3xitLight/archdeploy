#!/bin/bash

#############################################################
#########    Colorize and add text parameters       #########
#############################################################
#
blk=$(tput setaf 0)             # black		${blk}
red=$(tput setaf 1)             # red		${red}
grn=$(tput setaf 2)             # green		${grn}
ylw=$(tput setaf 3)             # yellow	${ylw}
blu=$(tput setaf 4)             # blue		${blu}
mga=$(tput setaf 5)             # magenta	${mga}
cya=$(tput setaf 6)             # cyan		${cya}
wht=$(tput setaf 7)             # white		${wht}
txtbld=$(tput bold)             # Bold	    ${bld}
bldblk=${txtbld}$(tput setaf 0) # black		${bldblk}
bldred=${txtbld}$(tput setaf 1) # red    	${bldred}
bldgrn=${txtbld}$(tput setaf 2) # green		${bldgrn}
bldylw=${txtbld}$(tput setaf 3) # yellow 	${bldylw}
bldblu=${txtbld}$(tput setaf 4) # blue		${bldblu}
bldmga=${txtbld}$(tput setaf 5) # magenta	${bldmga}
bldcya=${txtbld}$(tput setaf 6) # cyan		${bldcya}
bldwht=${txtbld}$(tput setaf 7) # white 	${bldwht}
txtrst=$(tput sgr0)             # Reset 	${txtrst}


#############################################################
#########                 CHECK IF ROOT             #########
#############################################################

if [[ "${USER}" != "root" ]] ; then
   echo "Must run as root."
   exit 1
fi

#############################################################
#########               VARIABLES                   #########
#############################################################
GATEWAY="$(route -n | grep 'UG[ \t]' | awk '{print $2}')"
GATEWAY=$GATEWAY
DNS=$GATEWAY
NetCard=$(ip addr show | awk '/inet.*brd/{print $NF; exit}')
STATUS=$(ufw status)

#############################################################
#########              START SCRIPT                 #########
#############################################################

echo
echo 
echo "${bldred}########################################${txtrst}"
echo "${ylw}                                           ${txtrst}"
echo "${ylw} # Setup UFW                               ${txtrst}"
echo "${ylw}                                           ${txtrst}"
echo "${ylw} # Interface: $NetCard                     ${txtrst}"
echo "${ylw} # Gateway:   $GATEWAY                     ${txtrst}"
echo "${ylw} # DNS:       $DNS                         ${txtrst}"
echo "${ylw}                                           ${txtrst}"
echo "${bldred}########################################${txtrst} ${ylw}"
echo ${txtrst}
echo 
sleep 2

#
cp -r ufw /etc/default/ufw
systemctl enable ufw && sudo systemctl start ufw
ufw disable
ufw reset
#
ufw default deny incoming
ufw default deny forward
ufw default deny outgoing
#
ufw allow out on ${NetCard} to ${DNS} proto tcp port 53 comment 'allow DNS'
ufw allow out on ${NetCard} to ${DNS} proto udp port 53 comment 'allow DNS'
ufw allow out on ${NetCard} to any proto tcp port 80 comment 'allow HTTP'
ufw allow out on ${NetCard} to any proto tcp port 443 comment 'allow HTTPS'
ufw allow out on ${NetCard} to ${GATEWAY} proto tcp port 22 comment 'allow SSH'
#
ufw logging low
#
ufw enable

echo ${txtrst} 
echo ${grn}
echo
ufw status numbered
echo ${txtrst} 
#


#############################################################
#########                 FINISH                    #########
#############################################################
