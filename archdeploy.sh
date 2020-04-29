#!/usr/bin/env bash
set -e

# Arch Linux Install Script installs unattended, automated
# and customized Arch Linux system.
# Copyright (C) 2018 picodotdev

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

# This script is hosted at https://github.com/picodotdev/alis. For new features,
# improvements and bugs fill an issue in GitHub or make a pull request.
# Pull Request are welcome!
#
# If you test it in real hardware please send me an email to pico.dev@gmail.com with
# the machine description and tell me if somethig goes wrong or all works fine.
#
# Please, don't ask for support for this script in Arch Linux forums, first read
# the Arch Linux wiki [1], the Installation Guide [2] and the General
# Recomendations [3], later compare the commands with those of this script.
#
# [1] https://wiki.archlinux.org
# [2] https://wiki.archlinux.org/index.php/Installation_guide
# [3] https://wiki.archlinux.org/index.php/General_recommendations

# Usage:
# # loadkeys es
# # curl https://raw.githubusercontent.com/picodotdev/alis/master/download.sh | bash, or with URL shortener curl -sL https://bit.ly/2F3CATp | bash
# # vim alis.conf
# # ./alis.sh

KEYS="de"
LOG="false"
REPO_URL="https://github.com/3xitLight/aur-pkg-repo/raw/master/pkgbuilds/3xitlight/3xitlight-desktop/"
# partition
DEVICE="/dev/sda"
DEVICE_TRIM="true"
LVM="true"
FILE_SYSTEM_TYPE="ext4"
SWAP_SIZE="8GiB"
PARTITION_MODE="auto !custom !manual"
PARTITION_CUSTOM_PARTED_UEFI="mklabel gpt mkpart primary fat32 1MiB 512MiB mkpart primary $FILE_SYSTEM_TYPE 512MiB 100% set 1 boot"
PARTITION_CUSTOM_PARTED_BIOS="mklabel msdos mkpart primary ext4 4MiB 512MiB mkpart primary $FILE_SYSTEM_TYPE 512MiB 100% set 1 boot on"
PARTITION_CUSTOMMANUAL_BOOT="/dev/sda1 !/dev/vda1 !/dev/nvme0n1p1 !/dev/mmcblk0p1"
PARTITION_CUSTOMMANUAL_ROOT="/dev/sda2 !/dev/vda2 !/dev/nvme0n1p2 !/dev/mmcblk0p2"

# network_install
WIFI_HIDDEN=()
WIFI_HIDDEN=()
WIFI_KEY=()
WIFI_HIDDEN=()
PING_HOSTNAME="mirrors.kernel.org"

# install (precede with ! for not install)
PACMAN_MIRROR="https://mirror.pkgbuild.com/\$repo/os/\$arch"
KERNELS="!linux-lts !linux-lts-headers !linux-hardened !linux-hardened-headers !linux-zen !linux-zen-headers" # Additional kernels and headers (multiple)
KERNELS_COMPRESSION="gzip !bzip2 !lzma !xz !lzop !lz4"
KERNELS_PARAMETERS="" # eg. iommu=soft

# config
TIMEZONE="/usr/share/zoneinfo/Europe/Berlin"
LOCALES=("en_US.UTF-8 UTF-8" "en_US.UTF-8 UTF-8")
LOCALE_CONF=("LANG=en_US.UTF-8" "LANGUAGE=en_EN:en:en_US:en")
KEYMAP="KEYMAP=de"
KEYLAYOUT="de"
FONT=""
FONT_MAP=""
ADDITIONAL_USERS=() # eg. ("user1=password1" "user2=password2")

# mkinitcpio
HOOKS="base !udev !usr !resume !systemd !btrfs keyboard autodetect modconf block !net !dmraid !mdadm !mdadm_udev !keymap !consolefont !sd-vconsole !encrypt !lvm2 !sd-encrypt !sd-lvm2 fsck filesystems"
# bootloader
BOOTLOADER="grub"
# desktop
DESKTOP_ENVIRONMENT="mate"
DISPLAY_DRIVER="nvidia-dkms" # intel
KMS="false"
DISPLAY_DRIVER_DDX="false"
VULKAN="false"
DISPLAY_DRIVER_HARDWARE_ACCELERATION="false"
DISPLAY_DRIVER_HARDWARE_ACCELERATION_INTEL="!intel-media-driver !libva-intel-driver" # (single)
# packages (all multiple)
PACKAGES_PACMAN_BASE="wget which usb_modeswitch usbutils util-linux sysstat unrar unzip time systemd systemd-sysvcompat tar pciutils pacman-contrib nano m4 make texinfo kconfig libtool autoconf gvfs grep groff glibc glslang gettext flex gawk gcc gcc-libs gnupg findutils filesystem automake bash bash-completion bc binutils bison coreutils file"
PACKAGES_PACMAN_INTERNET="chromium firefox-developer-edition firejail reflector"
PACKAGES_PACMAN_MEDIA="vlc pulseaudio pulseaudio-alsa pulseaudio-equalizer-ladspa pavucontrol phonon-qt5-vlc smplayer smplayer-skins smplayer-themes"
PACKAGES_PACMAN_UTILITIES="mate-extra nvidia-settings nvidia-utils xterm xz yaml-cpp zip tilix sleuthkit qemu qemu-guest-agent qemu-arch-extra qemu-block-gluster qemu-block-iscsi qemu-block-rbd procps-ng psmisc ovmf p7zip mozo gpg-crypter mtd-utils mtools keybase gzip binwalk arj atril bzip2 cabextract cpio fastjar jfsutils lhasa"
PACKAGES_PACMAN_GRAPHICS="fcitx5-qt gimp kvantum-qt5"
PACKAGES_PACMAN_PROGRAMMING="vala qt5-webkit qt5-xmlpatterns geany geany-plugins cmake extra-cmake-modules gobject-introspection"
PACKAGES_PACMAN_SYSTEM="xf86-input-libinput xf86-video-intel xf86-video-nouveau xf86-video-vesa xorg-bdftopcf xorg-iceauth xorg-luit xorg-mkfontscale xorg-server xorg-sessreg xorg-setxkbmap xorg-smproxy xorg-x11perf xorg-xauth xorg-xbacklight xorg-xcmsdb xorg-xcursorgen xorg-xdpyinfo xorg-xdriinfo xorg-xev xorg-xgamma xorg-xhost xorg-xinit xorg-xinput xorg-xkbcomp xorg-xkbevd xorg-xkbutils xorg-xkill xorg-xlsatoms xorg-xlsclients xorg-xmodmap xorg-xpr xorg-xprop xorg-xrandr xorg-xrdb xorg-xrefresh xorg-xset xorg-xsetroot xorg-xvinfo xorg-xwd xorg-xwininfo xorg-xwud xdg-user-dirs xdialog rsync sed sharutils pv pwgen python python-requests python-setuptools python-capstone python-opengl python-pip os-prober mkinitcpio-utils  marco lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings ntfs-3g lrzip lsof lvm2 lzip hwdetect libvirt iftop intel-ucode htop gparted haveged grub-customizer gtk-engine-murrine gnome-disk-utility gnome-logs  android-tools exfat-utils f2fs-tools fakeroot btrfs-progs efibootmgr efitools cdrtools cpupower crda dconf-editor dialog dkms dosfstools e2fsprogs"
PACKAGES_PACMAN_NETWORK="networkmanager network-manager-applet networkmanager-openvpn network-manager-applet networkmanager-openvpn nm-connection-editor wpa_supplicant whois wireless-regdb wireless_tools vde2 traceroute transmission-gtk speedtest-cli openbsd-netcat openssh net-tools nftables nmap mobile-broadband-provider-info  libnetfilter_acct libnetfilter_cthelper libnetfilter_cttimeout libnetfilter_log libnetfilter_queue ldns horst gnome-nettool arp-scan bridge-utils dnsmasq dnstracer dstat ebtables iperf3 iproute2 iputils"
PACKAGES_PACMAN_SECURITY="wireshark-qt vulscan tcpdump logwatch apparmor clamav clamtk ufw  gufw openvpn"
# PACKAGES_PACMAN_OTHERS="android-tools apparmor arj arp-scan arptables atril autoconf automake bash bash-completion bc binutils binwalk bison bridge-utils btrfs-progs bzip2 cabextract caja caja-image-converter caja-open-terminal caja-sendto caja-xattr-tags cdrtools chromium ckbcomp clamav clamtk coreutils cpio cpupower crda dconf-editor dialog dkms dnsmasq dnstracer dosfstools dstat dtc e2fsprogs ebtables efibootmgr efitools engrampa eom exfat-utils extra-cmake-modules f2fs-tools fakeroot fastjar fcitx5-qt file filesystem findutils firefox-developer-edition firejail flex gawk gcc gcc-libs gnupg geany geany-plugins gettext gimp glibc glslang gnome-disk-utility gnome-logs gnome-nettool gobject-introspection gparted gpg-crypter grep groff grub-customizer gtk-engine-murrine gufw gvfs gzip haveged hdparm horst htop hwdetect iftop intel-ucode intltool iperf3 iproute2 iputils jfsutils kconfig keybase kvantum-qt5 ldns lhasa libnetfilter_acct libnetfilter_cthelper libnetfilter_cttimeout libnetfilter_log libnetfilter_queue libtool libvirt lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings linux-hardened linux-hardened-headers linux-headers logwatch lrzip lsof lvm2 lzip m4 make marco mkinitcpio-utils mobile-broadband-provider-info mozo mtd-utils mtools nano net-tools nftables nload nmap ntfs-3g openssh openvpn os-prober openbsd-netcat ovmf p7zip pacman-contrib pavucontrol pciutils phonon-qt5-vlc procps-ng psmisc pulseaudio pulseaudio-alsa pulseaudio-equalizer-ladspa pv pwgen python python-requests python-capstone python-opengl python-pip python-setuptools qemu qemu-arch-extra qemu-block-gluster qemu-block-iscsi qemu-block-rbd qemu-guest-agent qt5-webkit qt5-xmlpatterns reflector rsync sed sharutils sleuthkit smplayer smplayer-skins smplayer-themes speedtest-cli sysstat systemd systemd-sysvcompat tar tcpdump tilix time traceroute transmission-gtk ufw unrar unzip usb_modeswitch usbutils util-linux vala vde2 vlc vulscan wget which whois wireless-regdb wireless_tools wireshark-qt wpa_supplicant xdg-user-dirs xdialog xf86-input-libinput xf86-video-intel xf86-video-nouveau xf86-video-vesa xorg-bdftopcf xorg-iceauth xorg-luit xorg-mkfontscale xorg-server xorg-sessreg xorg-setxkbmap xorg-smproxy xorg-x11perf xorg-xauth xorg-xbacklight xorg-xcmsdb xorg-xcursorgen xorg-xdpyinfo xorg-xdriinfo xorg-xev xorg-xgamma xorg-xhost xorg-xinit xorg-xinput xorg-xkbcomp xorg-xkbevd xorg-xkbutils xorg-xkill xorg-xlsatoms xorg-xlsclients xorg-xmodmap xorg-xpr xorg-xprop xorg-xrandr xorg-xrdb xorg-xrefresh xorg-xset xorg-xsetroot xorg-xvinfo xorg-xwd xorg-xwininfo xorg-xwud xterm xz yaml-cpp zip"
# PACKAGES_PACMAN_DEVELOPER="bcc bcc-tools python-bcc archiso bin86 boost boost-libs bpf ccache devtools jdk-openjdk jre-openjdk namcap patch pkgconf pkgfile squashfs-tools qtcreator texinfo"
# PACKAGES_PACMAN_CUSTOM="3xitlight-fonts 3xitlight-icons abrus-gtk-theme-gitchromium-widevine geany-themes-git netactview pamac-classic protonvpn-cli-ng qtwebflix-git repoctl rtl88xxau-aircrack-dkms-git spotify tilix-themes-git vdhcoapp yay zenmap"
AUR="yay"
PACKAGES_AUR_INTERNET=""
PACKAGES_AUR_MULTIMEDIA=""
PACKAGES_AUR_UTILITIES=""
PACKAGES_AUR_DOCUMENTS_AND_TEXT=""
PACKAGES_AUR_SECURITY=""
PACKAGES_AUR_SCIENCE=""
PACKAGES_AUR_OTHERS=""
PACKAGES_AUR_DEVELOPER=""
PACKAGES_AUR_CUSTOM=""

PACKAGES_PACMAN="$PACKAGES_PACMAN_BASE $PACKAGES_PACMAN_INTERNET $PACKAGES_PACMAN_MEDIA $PACKAGES_PACMAN_UTILITIES $PACKAGES_PACMAN_GRAPHICS $PACKAGES_PACMAN_PROGRAMMING $PACKAGES_PACMAN_SYSTEM $PACKAGES_PACMAN_NETWORK $PACKAGES_PACMAN_SECURITY"
PACKAGES_AUR=""

#reboot
REBOOT="false"

# global variables (no configuration, don't edit)
HOSTNAME=""
USER_NAME=""
ROOT_PASSWORD=""
ROOT_PASSWORD_RETYPE=""
USER_PASSWORD=""
USER_PASSWORD_RETYPE=""
LUKS_PASSWORD=""
LUKS_PASSWORD_RETYPE=""
BIOS_TYPE=""
PARTITION_BOOT=""
PARTITION_ROOT=""
PARTITION_BOOT_NUMBER=""
PARTITION_ROOT_NUMBER=""
DEVICE_ROOT=""
DEVICE_LVM=""
LUKS_DEVICE_NAME="cryptroot"
LVM_VOLUME_GROUP="vg"
LVM_VOLUME_LOGICAL="root"
SWAPFILE=""
BOOT_DIRECTORY=""
ESP_DIRECTORY=""
#PARTITION_BOOT_NUMBER=0
UUID_BOOT=""
UUID_ROOT=""
PARTUUID_BOOT=""
PARTUUID_ROOT=""
DEVICE_SATA=""
DEVICE_NVME=""
DEVICE_MMC=""
CPU_VENDOR=""
VIRTUALBOX=""
CMDLINE_LINUX_ROOT=""
CMDLINE_LINUX=""
ADDITIONAL_USER_NAMES_ARRAY=()
ADDITIONAL_USER_PASSWORDS_ARRAY=()

LOG_FILE="archdeploy.log"

RED='\033[0;31m'
GREEN='\033[0;32m'
LIGHT_BLUE='\033[1;34m'
NC='\033[0m'


function get_lvmpasswd() {
	while true; do
	read -s -p "Password for LUKS: " LUKS_PASSWORD
	echo
	read -s -p "Retype Password: " LUKS_PASSWORD_RETYPE
	echo
	[ "$LUKS_PASSWORD" = "$LUKS_PASSWORD_RETYPE" ] && break
	echo "Please try again"
	done
	#echo $USER_PASSWORD
	#LUKS_PASSWORD=$USER_PASSWORD
	#LUKS_PASSWORD_RETYPE=$LUKS_PASSWORD
}

function get_hostname() {
	echo
	read -p "Enter Hostname: "  HOSTNAME
	echo "hostname set to: $HOSTNAME!"
	echo
	sleep 1
}

function get_username() {
	echo
	read -p "Enter Username: "  USER_NAME
	echo
	echo "Hello $USER_NAME !"
	echo
	sleep 1
	USER_NAME=$USER_NAME
}

function get_userpasswd() {
	while true; do
	echo
	read -s -p "Password for $USER_NAME: " USER_PASSWORD
	echo
	sleep 1
	echo
	read -s -p "Retype Password: " USER_PASSWORD_RETYPE
	echo
	sleep 1
	echo
	[ "$USER_PASSWORD" = "$USER_PASSWORD_RETYPE" ] && break
	echo "Please try again"
	echo
	sleep 1
	done
	#echo $USER_PASSWORD
	#USER_PASSWORD=$USER_PASSWORD
	#USER_PASSWORD_RETYPE=$USER_PASSWORD
	#USER_PASSWORD_RETYPE=$USER_PASSWORD_RETYPE
}

function get_rootpasswd() {
	while true; do
	read -s -p "Set root Password: " ROOT_PASSWORD
	echo
	echo
	sleep 1
	read -s -p "Password (again): " ROOT_PASSWORD_RETYPE
	echo
	echo
	sleep 1
	[ "$ROOT_PASSWORD" = "$ROOT_PASSWORD_RETYPE" ] && break
	echo "Please try again"
	echo
	sleep 1
	done
	#ROOT_PASSWORD=$ROOT_PASSWORD
	#ROOT_PASSWORD_RETYPE=$ROOT_PASSWORD
	#ROOT_PASSWORD_RETYPE=$ROOT_PASSWORD_RETYPE
}

function configuration_install() {
    ADDITIONAL_USER_NAMES_ARRAY=($ADDITIONAL_USER_NAMES)
    ADDITIONAL_USER_PASSWORDS_ARRAY=($ADDITIONAL_USER_PASSWORDS)
}

function sanitize_variables() {
    DEVICE=$(sanitize_variable "$DEVICE")
    PARTITION_MODE=$(sanitize_variable "$PARTITION_MODE")
    PARTITION_CUSTOMMANUAL_BOOT=$(sanitize_variable "$PARTITION_CUSTOMMANUAL_BOOT")
    PARTITION_CUSTOMMANUAL_ROOT=$(sanitize_variable "$PARTITION_CUSTOMMANUAL_ROOT")
    FILE_SYSTEM_TYPE=$(sanitize_variable "$FILE_SYSTEM_TYPE")
    SWAP_SIZE=$(sanitize_variable "$SWAP_SIZE")
    KERNELS=$(sanitize_variable "$KERNELS")
    KERNELS_COMPRESSION=$(sanitize_variable "$KERNELS_COMPRESSION")
    BOOTLOADER=$(sanitize_variable "$BOOTLOADER")
    DESKTOP_ENVIRONMENT=$(sanitize_variable "$DESKTOP_ENVIRONMENT")
    DISPLAY_DRIVER=$(sanitize_variable "$DISPLAY_DRIVER")
    DISPLAY_DRIVER_HARDWARE_ACCELERATION_INTEL=$(sanitize_variable "$DISPLAY_DRIVER_HARDWARE_ACCELERATION_INTEL")
    PACKAGES_PACMAN=$(sanitize_variable "$PACKAGES_PACMAN")
    AUR=$(sanitize_variable "$AUR")
    PACKAGES_AUR=$(sanitize_variable "$PACKAGES_AUR")
}

function sanitize_variable() {
    VARIABLE=$1
    VARIABLE=$(echo $VARIABLE | sed "s/![^ ]*//g") # remove disabled
    VARIABLE=$(echo $VARIABLE | sed "s/ {2,}/ /g") # remove unnecessary white spaces
    VARIABLE=$(echo $VARIABLE | sed 's/^[[:space:]]*//') # trim leading
    VARIABLE=$(echo $VARIABLE | sed 's/[[:space:]]*$//') # trim trailing
    echo "$VARIABLE"
}

function check_variables() {
    check_variables_value "KEYS" "$KEYS"
    check_variables_boolean "LOG" "$LOG"
    check_variables_value "DEVICE" "$DEVICE"
    check_variables_boolean "DEVICE_TRIM" "$DEVICE_TRIM"
    check_variables_boolean "LVM" "$LVM"
    check_variables_list "FILE_SYSTEM_TYPE" "$FILE_SYSTEM_TYPE" "ext4 btrfs xfs"
    check_variables_equals "LUKS_PASSWORD" "LUKS_PASSWORD_RETYPE" "$LUKS_PASSWORD" "$LUKS_PASSWORD_RETYPE"
    check_variables_list "PARTITION_MODE" "$PARTITION_MODE" "auto custom manual" "true"
    if [ "$PARTITION_MODE" == "custom" ]; then
        check_variables_value "PARTITION_CUSTOM_PARTED_UEFI" "$PARTITION_CUSTOM_PARTED_UEFI"
        check_variables_value "PARTITION_CUSTOM_PARTED_BIOS" "$PARTITION_CUSTOM_PARTED_BIOS"
    fi
    if [ "$PARTITION_MODE" == "custom" -o "$PARTITION_MODE" == "manual" ]; then
        check_variables_value "PARTITION_CUSTOMMANUAL_BOOT" "$PARTITION_CUSTOMMANUAL_BOOT"
        check_variables_value "PARTITION_CUSTOMMANUAL_ROOT" "$PARTITION_CUSTOMMANUAL_ROOT"
    fi
    if [ "$LVM" == "true" ]; then
        check_variables_list "PARTITION_MODE" "$PARTITION_MODE" "auto" "true"
    fi
    check_variables_value "PING_HOSTNAME" "$PING_HOSTNAME"
    check_variables_value "PACMAN_MIRROR" "$PACMAN_MIRROR"
    check_variables_list "KERNELS" "$KERNELS" "linux-lts linux-lts-headers linux-hardened linux-hardened-headers linux-zen linux-zen-headers" "false"
    check_variables_list "KERNELS_COMPRESSION" "$KERNELS_COMPRESSION" "gzip bzip2 lzma xz lzop lz4" "false"
    check_variables_value "TIMEZONE" "$TIMEZONE"
    check_variables_value "LOCALES" "$LOCALES"
    check_variables_value "LOCALE_CONF" "$LOCALE_CONF"
    check_variables_value "LANG" "$LANG"
    check_variables_value "KEYMAP" "$KEYMAP"
    check_variables_value "HOSTNAME" "$HOSTNAME"
    check_variables_value "USER_NAME" "$USER_NAME"
    check_variables_value "USER_PASSWORD" "$USER_PASSWORD"
    check_variables_equals "ROOT_PASSWORD" "ROOT_PASSWORD_RETYPE" "$ROOT_PASSWORD" "$ROOT_PASSWORD_RETYPE"
    check_variables_equals "USER_PASSWORD" "USER_PASSWORD_RETYPE" "$USER_PASSWORD" "$USER_PASSWORD_RETYPE"
    check_variables_value "HOOKS" "$HOOKS"
    check_variables_list "BOOTLOADER" "$BOOTLOADER" "grub refind systemd"
    check_variables_list "AUR" "$AUR" "aurman yay" "false"
    check_variables_list "DESKTOP_ENVIRONMENT" "$DESKTOP_ENVIRONMENT" "gnome kde xfce mate cinnamon lxde" "false"
    check_variables_list "DISPLAY_DRIVER" "$DISPLAY_DRIVER" "intel amdgpu ati nvidia nvidia-lts nvidia-dkms nvidia-390xx nvidia-390xx-lts nvidia-390xx-dkms nouveau" "false"
    check_variables_boolean "KMS" "$KMS"
    check_variables_boolean "DISPLAY_DRIVER_DDX" "$DISPLAY_DRIVER_DDX"
    check_variables_boolean "DISPLAY_DRIVER_HARDWARE_ACCELERATION" "$DISPLAY_DRIVER_HARDWARE_ACCELERATION"
    check_variables_list "DISPLAY_DRIVER_HARDWARE_ACCELERATION_INTEL" "$DISPLAY_DRIVER_HARDWARE_ACCELERATION_INTEL" "intel-media-driver libva-intel-driver" "false"
    check_variables_boolean "REBOOT" "$REBOOT"
}

function check_variables_value() {
    NAME=$1
    VALUE=$2
    if [ -z "$VALUE" ]; then
        echo "$NAME environment variable must have a value."
        exit
    fi
}

function check_variables_boolean() {
    NAME=$1
    VALUE=$2
    check_variables_list "$NAME" "$VALUE" "true false"
}

function check_variables_list() {
    NAME=$1
    VALUE=$2
    VALUES=$3
    REQUIRED=$4
    if [ "$REQUIRED" == "" -o "$REQUIRED" == "true" ]; then
        check_variables_value "$NAME" "$VALUE"
    fi

    if [ "$VALUE" != "" -a -z "$(echo "$VALUES" | grep -F -w "$VALUE")" ]; then
        echo "$NAME environment variable value [$VALUE] must be in [$VALUES]."
        exit
    fi
}

function check_variables_equals() {
    NAME1=$1
    NAME2=$2
    VALUE1=$3
    VALUE2=$4
    if [ "$VALUE1" != "$VALUE2" ]; then
        echo "$NAME1 and $NAME2 must be equal [$VALUE1, $VALUE2]."
        exit
    fi
}

function check_variables_size() {
    NAME=$1
    SIZE_EXPECT=$2
    SIZE=$3
    if [ "$SIZE_EXPECT" != "$SIZE" ]; then
        echo "$NAME array size [$SIZE] must be [$SIZE_EXPECT]."
        exit
    fi
}

function warning() {
    echo -e "${LIGHT_BLUE}Welcome to Arch Linux Install Script${NC}"
    echo ""
    echo -e "${RED}Warning"'!'"${NC}"
    echo -e "${RED}This script deletes all partitions of the persistent${NC}"
    echo -e "${RED}storage and continuing all your data in it will be lost.${NC}"
    echo ""
    read -p "Do you want to continue? [y/N] " yn
    case $yn in
        [Yy]* )
            ;;
        [Nn]* )
            exit
            ;;
        * )
            exit
            ;;
    esac
}

function init() {
    print_step "init()"

    init_log
    loadkeys $KEYS
}

function init_log() {
    if [ "$LOG" == "true" ]; then
        exec > >(tee -a $LOG_FILE)
        exec 2> >(tee -a $LOG_FILE >&2)
    fi
    set -o xtrace
}

function facts() {
    print_step "facts()"

    if [ -d /sys/firmware/efi ]; then
        BIOS_TYPE="uefi"
    else
        BIOS_TYPE="bios"
    fi

    DEVICE_SATA="false"
    DEVICE_NVME="false"
    DEVICE_MMC="false"
    if [ -n "$(echo $DEVICE | grep "^/dev/[a-z]d[a-z]")" ]; then
        DEVICE_SATA="true"
    elif [ -n "$(echo $DEVICE | grep "^/dev/nvme")" ]; then
        DEVICE_NVME="true"
    elif [ -n "$(echo $DEVICE | grep "^/dev/mmc")" ]; then
        DEVICE_MMC="true"
    fi

    if [ -n "$(lscpu | grep GenuineIntel)" ]; then
        CPU_VENDOR="intel"
    elif [ -n "$(lscpu | grep AuthenticAMD)" ]; then
        CPU_VENDOR="amd"
    fi

    if [ -n "$(lspci | grep -i virtualbox)" ]; then
        VIRTUALBOX="true"
    fi
}

function check_facts() {
    if [ "$BIOS_TYPE" == "bios" ]; then
        check_variables_list "BOOTLOADER" "$BOOTLOADER" "grub"
    fi
}

function prepare() {
    print_step "prepare()"

    configure_time
    prepare_partition
    configure_network

    pacman -Sy
}

function configure_time() {
    timedatectl set-ntp true
}

function prepare_partition() {
    if [ -d /mnt/boot ]; then
        umount /mnt/boot
        umount /mnt
    fi
    if [ -e "/dev/mapper/$LVM_VOLUME_GROUP-$LVM_VOLUME_LOGICAL" ]; then
        lvremove --force "$LVM_VOLUME_GROUP-$LVM_VOLUME_LOGICAL"
    fi
    if [ -e "/dev/mapper/$LVM_VOLUME_GROUP" ]; then
        vgremove --force "/dev/mapper/$LVM_VOLUME_GROUP"
        pvremove "/dev/mapper/$LUKS_DEVICE_NAME"
    fi
    if [ -e "/dev/mapper/$LUKS_DEVICE_NAME" ]; then
        cryptsetup close $LUKS_DEVICE_NAME
    fi
    partprobe $DEVICE
}

function configure_network() {
    if [ -n "$WIFI_INTERFACE" ]; then
        cp /etc/netctl/examples/wireless-wpa /etc/netctl
        chmod 600 /etc/netctl/wireless-wpa

        sed -i 's/^Interface=.*/Interface='"$WIFI_INTERFACE"'/' /etc/netctl/wireless-wpa
        sed -i 's/^ESSID=.*/ESSID='"$WIFI_ESSID"'/' /etc/netctl/wireless-wpa
        sed -i 's/^Key=.*/Key='"$WIFI_KEY"'/' /etc/netctl/wireless-wpa
        if [ "$WIFI_HIDDEN" == "true" ]; then
            sed -i 's/^#Hidden=.*/Hidden=yes/' /etc/netctl/wireless-wpa
        fi

        netctl stop-all
        netctl start wireless-wpa
        sleep 10
    fi

    # only on ping -c 1, packer gets stuck if -c 5
    ping -c 1 -i 2 -W 5 -w 30 $PING_HOSTNAME
    if [ $? -ne 0 ]; then
        echo "Network ping check failed. Cannot continue."
        exit
    fi
}

function partition() {
    print_step "partition()"

    # setup
    if [ "$PARTITION_MODE" == "auto" ]; then
        PARTITION_PARTED_UEFI="mklabel gpt mkpart primary fat32 1MiB 512MiB mkpart primary $FILE_SYSTEM_TYPE 512MiB 100% set 1 boot on"
        PARTITION_PARTED_BIOS="mklabel msdos mkpart primary ext4 4MiB 512MiB mkpart primary $FILE_SYSTEM_TYPE 512MiB 100% set 1 boot on"

        if [ "$BIOS_TYPE" == "uefi" ]; then
            if [ "$DEVICE_SATA" == "true" ]; then
                PARTITION_BOOT="${DEVICE}1"
                PARTITION_ROOT="${DEVICE}2"
                DEVICE_ROOT="${DEVICE}2"
            fi

            if [ "$DEVICE_NVME" == "true" ]; then
                PARTITION_BOOT="${DEVICE}p1"
                PARTITION_ROOT="${DEVICE}p2"
                DEVICE_ROOT="${DEVICE}p2"
            fi

            if [ "$DEVICE_MMC" == "true" ]; then
                PARTITION_BOOT="${DEVICE}p1"
                PARTITION_ROOT="${DEVICE}p2"
                DEVICE_ROOT="${DEVICE}p2"
            fi
        fi

        if [ "$BIOS_TYPE" == "bios" ]; then
            if [ "$DEVICE_SATA" == "true" ]; then
                PARTITION_BOOT="${DEVICE}1"
                PARTITION_ROOT="${DEVICE}2"
                DEVICE_ROOT="${DEVICE}2"
            fi

            if [ "$DEVICE_NVME" == "true" ]; then
                PARTITION_BOOT="${DEVICE}p1"
                PARTITION_ROOT="${DEVICE}p2"
                DEVICE_ROOT="${DEVICE}p2"
            fi

            if [ "$DEVICE_MMC" == "true" ]; then
                PARTITION_BOOT="${DEVICE}p1"
                PARTITION_ROOT="${DEVICE}p2"
                DEVICE_ROOT="${DEVICE}p2"
            fi
        fi
    elif [ "$PARTITION_MODE" == "custom" ]; then
        PARTITION_PARTED_UEFI="$PARTITION_CUSTOM_PARTED_UEFI"
        PARTITION_PARTED_BIOS="$PARTITION_CUSTOM_PARTED_BIOS"
    fi

    if [ "$PARTITION_MODE" == "custom" -o "$PARTITION_MODE" == "manual" ]; then
        PARTITION_BOOT="$PARTITION_CUSTOMMANUAL_BOOT"
        PARTITION_ROOT="$PARTITION_CUSTOMMANUAL_ROOT"
        DEVICE_ROOT="${PARTITION_ROOT}"
    fi

    PARTITION_BOOT_NUMBER="$PARTITION_BOOT"
    PARTITION_ROOT_NUMBER="$PARTITION_ROOT"
    PARTITION_BOOT_NUMBER="${PARTITION_BOOT_NUMBER//\/dev\/sda/}"
    PARTITION_BOOT_NUMBER="${PARTITION_BOOT_NUMBER//\/dev\/vda/}"
    PARTITION_BOOT_NUMBER="${PARTITION_BOOT_NUMBER//\/dev\/nvme0n1p/}"
    PARTITION_BOOT_NUMBER="${PARTITION_BOOT_NUMBER//\/dev\/mmcblk0p/}"
    PARTITION_ROOT_NUMBER="${PARTITION_ROOT_NUMBER//\/dev\/sda/}"
    PARTITION_ROOT_NUMBER="${PARTITION_ROOT_NUMBER//\/dev\/vda/}"
    PARTITION_ROOT_NUMBER="${PARTITION_ROOT_NUMBER//\/dev\/nvme0n1p/}"
    PARTITION_ROOT_NUMBER="${PARTITION_ROOT_NUMBER//\/dev\/mmcblk0p/}"

    # partition
    if [ "$FILE_SYSTEM_TYPE" == "f2fs" ]; then
        pacman -S f2fs-tools
    fi

    if [ "$PARTITION_MODE" == "auto" ]; then
        sgdisk --zap-all $DEVICE
        wipefs -a $DEVICE
    fi

    if [ "$PARTITION_MODE" == "auto" -o "$PARTITION_MODE" == "custom" ]; then
        if [ "$BIOS_TYPE" == "uefi" ]; then
            parted -s $DEVICE $PARTITION_PARTED_UEFI

            sgdisk -t=$PARTITION_BOOT_NUMBER:ef00 $DEVICE
            if [ -n "$LUKS_PASSWORD" ]; then
                sgdisk -t=$PARTITION_ROOT_NUMBER:8309 $DEVICE
            elif [ "$LVM" == "true" ]; then
                sgdisk -t=$PARTITION_ROOT_NUMBER:8e00 $DEVICE
            fi
        fi

        if [ "$BIOS_TYPE" == "bios" ]; then
            parted -s $DEVICE $PARTITION_PARTED_BIOS
        fi
    fi

    # luks and lvm
    if [ -n "$LUKS_PASSWORD" ]; then
        echo -n "$LUKS_PASSWORD" | cryptsetup --key-size=512 --key-file=- luksFormat --type luks2 $PARTITION_ROOT
        echo -n "$LUKS_PASSWORD" | cryptsetup --key-file=- open $PARTITION_ROOT $LUKS_DEVICE_NAME
        sleep 5
    fi

    if [ "$LVM" == "true" ]; then
        if [ -n "$LUKS_PASSWORD" ]; then
            DEVICE_LVM="/dev/mapper/$LUKS_DEVICE_NAME"
        else
            DEVICE_LVM="$DEVICE_ROOT"
        fi

        pvcreate $DEVICE_LVM
        vgcreate $LVM_VOLUME_GROUP $DEVICE_LVM
        lvcreate -l 100%FREE -n $LVM_VOLUME_LOGICAL $LVM_VOLUME_GROUP
    fi

    if [ -n "$LUKS_PASSWORD" ]; then
        DEVICE_ROOT="/dev/mapper/$LUKS_DEVICE_NAME"
    fi
    if [ "$LVM" == "true" ]; then
        DEVICE_ROOT="/dev/mapper/$LVM_VOLUME_GROUP-$LVM_VOLUME_LOGICAL"
    fi

    # format
    if [ "$BIOS_TYPE" == "uefi" ]; then
        wipefs -a $PARTITION_BOOT
        wipefs -a $DEVICE_ROOT
        mkfs.fat -n ESP -F32 $PARTITION_BOOT
        mkfs."$FILE_SYSTEM_TYPE" -L root $DEVICE_ROOT
    fi

    if [ "$BIOS_TYPE" == "bios" ]; then
        wipefs -a $PARTITION_BOOT
        wipefs -a $DEVICE_ROOT
        mkfs."$FILE_SYSTEM_TYPE" -L boot $PARTITION_BOOT
        mkfs."$FILE_SYSTEM_TYPE" -L root $DEVICE_ROOT
    fi

    PARTITION_OPTIONS="defaults"

    if [ "$DEVICE_TRIM" == "true" ]; then
        PARTITION_OPTIONS="$PARTITION_OPTIONS,noatime"
    fi

    # mount
    if [ "$FILE_SYSTEM_TYPE" == "btrfs" ]; then
        mount -o "$PARTITION_OPTIONS" "$DEVICE_ROOT" /mnt
        btrfs subvolume create /mnt/root
        btrfs subvolume create /mnt/home
        btrfs subvolume create /mnt/var
        btrfs subvolume create /mnt/snapshots
        umount /mnt

        mount -o "subvol=root,$PARTITION_OPTIONS,compress=lzo" "$DEVICE_ROOT" /mnt

        mkdir /mnt/{boot,home,var,snapshots}
        mount -o "$PARTITION_OPTIONS" "$PARTITION_BOOT" /mnt/boot
        mount -o "subvol=home,$PARTITION_OPTIONS,compress=lzo" "$DEVICE_ROOT" /mnt/home
        mount -o "subvol=var,$PARTITION_OPTIONS,compress=lzo" "$DEVICE_ROOT" /mnt/var
        mount -o "subvol=snapshots,$PARTITION_OPTIONS,compress=lzo" "$DEVICE_ROOT" /mnt/snapshots
    else
        mount -o "$PARTITION_OPTIONS" "$DEVICE_ROOT" /mnt

        mkdir /mnt/boot
        mount -o "$PARTITION_OPTIONS" "$PARTITION_BOOT" /mnt/boot
    fi

    # swap
    # btrfs: https://btrfs.wiki.kernel.org/index.php/FAQ#Does_btrfs_support_swap_files.3F
    # btrfs: https://wiki.archlinux.org/index.php/Btrfs#Disabling_CoW
    # btrfs: https://jlk.fjfi.cvut.cz/arch/manpages/man/btrfs.5#MOUNT_OPTIONS
    if [ -n "$SWAP_SIZE" -a "$FILE_SYSTEM_TYPE" != "btrfs" ]; then
        fallocate -l $SWAP_SIZE "/mnt/swapfile"
        chmod 600 "/mnt/swapfile"
        mkswap "/mnt/swapfile"
    fi

    # set variables
    BOOT_DIRECTORY=/boot
    ESP_DIRECTORY=/boot
    UUID_BOOT=$(blkid -s UUID -o value $PARTITION_BOOT)
    UUID_ROOT=$(blkid -s UUID -o value $PARTITION_ROOT)
    PARTUUID_BOOT=$(blkid -s PARTUUID -o value $PARTITION_BOOT)
    PARTUUID_ROOT=$(blkid -s PARTUUID -o value $PARTITION_ROOT)
}

function install() {
    print_step "install()"
    if [ -n "$PACMAN_MIRROR" ]; then
        echo "Server=$PACMAN_MIRROR" > /etc/pacman.d/mirrorlist
    fi
	if [ "$1" ]; then addvline=$1$'\n'; fi
    sed -i 's/#Color/Color/' /etc/pacman.conf
    sed -i 's/#TotalDownload/TotalDownload/' /etc/pacman.conf
	cat <<EOT >> /etc/pacman.conf
${addvline}
[aur-pkg-repo]
SigLevel = Optional TrustAll 
Server = https://github.com/3xitLight/aur-pkg-repo/releases/download/2/
EOT

    pacstrap /mnt base base-devel linux

    sed -i 's/#Color/Color/' /mnt/etc/pacman.conf
    sed -i 's/#TotalDownload/TotalDownload/' /mnt/etc/pacman.conf
    cat <<EOT >> /mnt/etc/pacman.conf
${addvline}
[aur-pkg-repo]
SigLevel = Optional TrustAll 
Server = https://github.com/3xitLight/aur-pkg-repo/releases/download/2/
EOT
}

function configuration() {
    print_step "configuration()"

    genfstab -U /mnt >> /mnt/etc/fstab

    if [ -n "$SWAP_SIZE" -a "$FILE_SYSTEM_TYPE" != "btrfs" ]; then
        echo "# swap" >> /mnt/etc/fstab
        echo "/swapfile none swap defaults 0 0" >> /mnt/etc/fstab
        echo "" >> /mnt/etc/fstab
    fi

    if [ "$DEVICE_TRIM" == "true" ]; then
        sed -i 's/relatime/noatime/' /mnt/etc/fstab
        arch-chroot /mnt systemctl enable fstrim.timer
    fi

    arch-chroot /mnt ln -s -f $TIMEZONE /etc/localtime
    arch-chroot /mnt hwclock --systohc
    for LOCALE in "${LOCALES[@]}"; do
        sed -i "s/#$LOCALE/$LOCALE/" /etc/locale.gen
        sed -i "s/#$LOCALE/$LOCALE/" /mnt/etc/locale.gen
    done
    locale-gen
    arch-chroot /mnt locale-gen
    for VARIABLE in "${LOCALE_CONF[@]}"; do
        localectl set-locale "$VARIABLE"
        echo -e "$VARIABLE" >> /mnt/etc/locale.conf
    done
    echo -e "$KEYMAP\n$FONT\n$FONT_MAP" > /mnt/etc/vconsole.conf
    echo $HOSTNAME > /mnt/etc/hostname

    arch-chroot /mnt mkdir -p "/etc/X11/xorg.conf.d/"
    cat <<EOT > /mnt/etc/X11/xorg.conf.d/00-keyboard.conf
# Written by systemd-localed(8), read by systemd-localed and Xorg. It's
# probably wise not to edit this file manually. Use localectl(1) to
# instruct systemd-localed to update it.
Section "InputClass"
    Identifier "system-keyboard"
    MatchIsKeyboard "on"
    Option "XkbLayout" "$KEYLAYOUT"
EndSection
EOT

    if [ -n "$SWAP_SIZE" ]; then
        echo "vm.swappiness=10" > /mnt/etc/sysctl.d/99-sysctl.conf
    fi

    printf "$ROOT_PASSWORD\n$ROOT_PASSWORD" | arch-chroot /mnt passwd
}

function mkinitcpio_configuration() {
    print_step "mkinitcpio_configuration()"

    if [ "$KMS" == "true" ]; then
        MODULES=""
        case "$DISPLAY_DRIVER" in
            "intel" )
                MODULES="i915"
                ;;
            "nvidia" | "nvidia-lts"  | "nvidia-dkms" | "nvidia-390xx" | "nvidia-390xx-lts" | "nvidia-390xx-dkms" )
                MODULES="nvidia nvidia_modeset nvidia_uvm nvidia_drm"
                ;;
            "amdgpu" )
                MODULES="amdgpu"
                ;;
            "ati" )
                MODULES="radeon"
                ;;
            "nouveau" )
                MODULES="nouveau"
                ;;
        esac
        arch-chroot /mnt sed -i "s/^MODULES=()/MODULES=($MODULES)/" /etc/mkinitcpio.conf
    fi

    if [ "$LVM" == "true" ]; then
        pacman_install "lvm2"
    fi
    if [ "$FILE_SYSTEM_TYPE" == "btrfs" ]; then
        pacman_install "btrfs-progs"
    fi
    if [ "$FILE_SYSTEM_TYPE" == "f2fs" ]; then
        pacman_install "f2fs-tools"
    fi

    if [ "$BOOTLOADER" == "systemd" ]; then
        HOOKS=$(echo $HOOKS | sed 's/!systemd/systemd/')
        HOOKS=$(echo $HOOKS | sed 's/!sd-vconsole/sd-vconsole/')
        if [ "$LVM" == "true" ]; then
            HOOKS=$(echo $HOOKS | sed 's/!sd-lvm2/sd-lvm2/')
        fi
        if [ -n "$LUKS_PASSWORD" ]; then
            HOOKS=$(echo $HOOKS | sed 's/!sd-encrypt/sd-encrypt/')
        fi
    else
        HOOKS=$(echo $HOOKS | sed 's/!udev/udev/')
        HOOKS=$(echo $HOOKS | sed 's/!usr/usr/')
        HOOKS=$(echo $HOOKS | sed 's/!keymap/keymap/')
        HOOKS=$(echo $HOOKS | sed 's/!consolefont/consolefont/')
        if [ "$LVM" == "true" ]; then
            HOOKS=$(echo $HOOKS | sed 's/!lvm2/lvm2/')
        fi
        if [ -n "$LUKS_PASSWORD" ]; then
            HOOKS=$(echo $HOOKS | sed 's/!encrypt/encrypt/')
        fi
    fi
    HOOKS=$(sanitize_variable "$HOOKS")
    arch-chroot /mnt sed -i "s/^HOOKS=(.*)$/HOOKS=($HOOKS)/" /etc/mkinitcpio.conf

    if [ "$KERNELS_COMPRESSION" != "" ]; then
        arch-chroot /mnt sed -i 's/^#COMPRESSION="'"$KERNELS_COMPRESSION"'"/COMPRESSION="'"$KERNELS_COMPRESSION"'"/' /etc/mkinitcpio.conf
    fi
}

function kernels() {
    print_step "kernels()"

    pacman_install "linux-headers"
    if [ -n "$KERNELS" ]; then
        pacman_install "$KERNELS"
    fi
}

function mkinitcpio() {
    print_step "mkinitcpio()"

    arch-chroot /mnt mkinitcpio -P
}

function network() {
    print_step "network()"

    pacman_install "networkmanager"
    arch-chroot /mnt systemctl enable NetworkManager.service
}

function virtualbox() {
    print_step "virtualbox()"

    if [ -z "$KERNELS" ]; then
        pacman_install "virtualbox-guest-utils"
    else
        pacman_install "virtualbox-guest-utils virtualbox-guest-dkms"
    fi
}

function bootloader() {
    print_step "bootloader()"

    BOOTLOADER_ALLOW_DISCARDS=""

    if [ "$VIRTUALBOX" != "true" ]; then
        if [ "$CPU_VENDOR" == "intel" ]; then
            pacman_install "intel-ucode"
        fi
        if [ "$CPU_VENDOR" == "amd" ]; then
            pacman_install "amd-ucode"
        fi
    fi
    if [ "$LVM" == "true" ]; then
        CMDLINE_LINUX_ROOT="root=$DEVICE_ROOT"
    else
        CMDLINE_LINUX_ROOT="root=PARTUUID=$PARTUUID_ROOT"
    fi
    if [ -n "$LUKS_PASSWORD" ]; then
        if [ "$DEVICE_TRIM" == "true" ]; then
            BOOTLOADER_ALLOW_DISCARDS=":allow-discards"
        fi
        CMDLINE_LINUX="cryptdevice=PARTUUID=$PARTUUID_ROOT:$LUKS_DEVICE_NAME$BOOTLOADER_ALLOW_DISCARDS"
    fi
    if [ "$FILE_SYSTEM_TYPE" == "btrfs" ]; then
        CMDLINE_LINUX="$CMDLINE_LINUX rootflags=subvol=root"
    fi
    if [ "$KMS" == "true" ]; then
        case "$DISPLAY_DRIVER" in
            "nvidia" | "nvidia-390xx" | "nvidia-390xx-lts" )
                CMDLINE_LINUX="$CMDLINE_LINUX nvidia-drm.modeset=1"
                ;;
        esac
    fi

    if [ -n "$KERNELS_PARAMETERS" ]; then
        CMDLINE_LINUX="$CMDLINE_LINUX $KERNELS_PARAMETERS"
    fi

    case "$BOOTLOADER" in
        "grub" )
            grub
            ;;
        "refind" )
            refind
            ;;
        "systemd" )
            systemd
            ;;
    esac

    arch-chroot /mnt systemctl set-default multi-user.target
}

function grub() {
    pacman_install "grub dosfstools"
    arch-chroot /mnt sed -i 's/GRUB_DEFAULT=0/GRUB_DEFAULT=saved/' /etc/default/grub
    arch-chroot /mnt sed -i 's/#GRUB_SAVEDEFAULT="true"/GRUB_SAVEDEFAULT="true"/' /etc/default/grub
    arch-chroot /mnt sed -i -E 's/GRUB_CMDLINE_LINUX_DEFAULT="(.*) quiet"/GRUB_CMDLINE_LINUX_DEFAULT="\1"/' /etc/default/grub
    arch-chroot /mnt sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="'"$CMDLINE_LINUX"'"/' /etc/default/grub
    echo "" >> /mnt/etc/default/grub
    echo "# archdeploy" >> /mnt/etc/default/grub
    echo "GRUB_DISABLE_SUBMENU=y" >> /mnt/etc/default/grub

    if [ "$BIOS_TYPE" == "uefi" ]; then
        pacman_install "efibootmgr"
        arch-chroot /mnt grub-install --target=x86_64-efi --bootloader-id=grub --efi-directory=$ESP_DIRECTORY --recheck
        #arch-chroot /mnt efibootmgr --create --disk $DEVICE --part $PARTITION_BOOT_NUMBER --loader /EFI/grub/grubx64.efi --label "GRUB Boot Manager"
    fi
    if [ "$BIOS_TYPE" == "bios" ]; then
        arch-chroot /mnt grub-install --target=i386-pc --recheck $DEVICE
    fi

    arch-chroot /mnt grub-mkconfig -o "$BOOT_DIRECTORY/grub/grub.cfg"

    if [ "$VIRTUALBOX" == "true" ]; then
        echo -n "\EFI\grub\grubx64.efi" > "/mnt$ESP_DIRECTORY/startup.nsh"
    fi
}

function refind() {
    pacman_install "refind-efi"
    arch-chroot /mnt refind-install

    arch-chroot /mnt rm /boot/refind_linux.conf
    arch-chroot /mnt sed -i 's/^timeout.*/timeout 5/' "$ESP_DIRECTORY/EFI/refind/refind.conf"
    arch-chroot /mnt sed -i 's/^#scan_all_linux_kernels.*/scan_all_linux_kernels false/' "$ESP_DIRECTORY/EFI/refind/refind.conf"

    #arch-chroot /mnt sed -i 's/^#default_selection "+,bzImage,vmlinuz"/default_selection "+,bzImage,vmlinuz"/' "$ESP_DIRECTORY/EFI/refind/refind.conf"

    REFIND_MICROCODE=""

    if [ "$VIRTUALBOX" != "true" ]; then
        if [ "$CPU_VENDOR" == "intel" ]; then
            REFIND_MICROCODE="initrd=/intel-ucode.img"
        fi
        if [ "$CPU_VENDOR" == "amd" ]; then
            REFIND_MICROCODE="initrd=/amd-ucode.img"
        fi
    fi

    cat <<EOT >> "/mnt$ESP_DIRECTORY/EFI/refind/refind.conf"
# archdeploy
menuentry "Arch Linux" {
    volume   $PARTUUID_BOOT
    loader   /vmlinuz-linux
    initrd   /initramfs-linux.img
    icon     /EFI/refind/icons/os_arch.png
    options  "$REFIND_MICROCODE $CMDLINE_LINUX_ROOT rw $CMDLINE_LINUX"
    submenuentry "Boot using fallback initramfs"
	      initrd /initramfs-linux-fallback.img"
    }
    submenuentry "Boot to terminal"
	      add_options "systemd.unit=multi-user.target"
    }
}"

EOT
    if [[ $KERNELS =~ .*linux-lts.* ]]; then
        cat <<EOT >> "/mnt$ESP_DIRECTORY/EFI/refind/refind.conf"
menuentry "Arch Linux (lts)" {
    volume   $PARTUUID_BOOT
    loader   /vmlinuz-linux-lts
    initrd   /initramfs-linux-lts.img
    icon     /EFI/refind/icons/os_arch.png
    options  "$REFIND_MICROCODE $CMDLINE_LINUX_ROOT rw $CMDLINE_LINUX"
    submenuentry "Boot using fallback initramfs" {
	      initrd /initramfs-linux-lts-fallback.img
    }
    submenuentry "Boot to terminal" {
	      add_options "systemd.unit=multi-user.target"
    }
}

EOT
    fi
    if [[ $KERNELS =~ .*linux-hardened.* ]]; then
        cat <<EOT >> "/mnt$ESP_DIRECTORY/EFI/refind/refind.conf"
menuentry "Arch Linux (hardened)" {
    volume   $PARTUUID_BOOT
    loader   /vmlinuz-linux-hardened
    initrd   /initramfs-linux-hardened.img
    icon     /EFI/refind/icons/os_arch.png
    options  "$REFIND_MICROCODE $CMDLINE_LINUX_ROOT rw $CMDLINE_LINUX"
    submenuentry "Boot using fallback initramfs" {
	      initrd /initramfs-linux-lts-fallback.img
    }
    submenuentry "Boot to terminal" {
	      add_options "systemd.unit=multi-user.target"
    }
}

EOT
    fi
    if [[ $KERNELS =~ .*linux-zen.* ]]; then
        cat <<EOT >> "/mnt$ESP_DIRECTORY/EFI/refind/refind.conf"
menuentry "Arch Linux (zen)" {
    volume   $PARTUUID_BOOT
    loader   /vmlinuz-linux-zen
    initrd   /initramfs-linux-zen.img
    icon     /EFI/refind/icons/os_arch.png
    options  "$REFIND_MICROCODE $CMDLINE_LINUX_ROOT rw $CMDLINE_LINUX"
    submenuentry "Boot using fallback initramfs" {
	      initrd /initramfs-linux-lts-fallback.img
    }
    submenuentry "Boot to terminal" {
	      add_options "systemd.unit=multi-user.target"
    }
}

EOT
    fi

    if [ "$VIRTUALBOX" == "true" ]; then
        echo -n "\EFI\refind\refind_x64.efi" > "/mnt$ESP_DIRECTORY/startup.nsh"
    fi
}

function systemd() {
    arch-chroot /mnt systemd-machine-id-setup
    arch-chroot /mnt bootctl --path="$ESP_DIRECTORY" install

    arch-chroot /mnt mkdir -p "$ESP_DIRECTORY/loader/"
    arch-chroot /mnt mkdir -p "$ESP_DIRECTORY/loader/entries/"

    cat <<EOT > "/mnt$ESP_DIRECTORY/loader/loader.conf"
# archdeploy
timeout 5
default archlinux
editor 0
EOT

    arch-chroot /mnt mkdir -p "/etc/pacman.d/hooks/"

    cat <<EOT > "/mnt/etc/pacman.d/hooks/systemd-boot.hook"
[Trigger]
Type = Package
Operation = Upgrade
Target = systemd

[Action]
Description = Updating systemd-boot
When = PostTransaction
Exec = /usr/bin/bootctl update
EOT

    SYSTEMD_MICROCODE=""
    SYSTEMD_OPTIONS=""

    if [ "$VIRTUALBOX" != "true" ]; then
        if [ "$CPU_VENDOR" == "intel" ]; then
            SYSTEMD_MICROCODE="/intel-ucode.img"
        fi
        if [ "$CPU_VENDOR" == "amd" ]; then
            SYSTEMD_MICROCODE="/amd-ucode.img"
        fi
    fi

    if [ -n "$LUKS_PASSWORD" ]; then
       SYSTEMD_OPTIONS="luks.name=$UUID_ROOT=$LUKS_DEVICE_NAME luks.options=discard"
    fi

    echo "title Arch Linux" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux.conf"
    echo "efi /vmlinuz-linux" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux.conf"
    if [ -n "$SYSTEMD_MICROCODE" ]; then
        echo "initrd $SYSTEMD_MICROCODE" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux.conf"
    fi
    echo "initrd /initramfs-linux.img" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux.conf"
    echo "options initrd=initramfs-linux.img $CMDLINE_LINUX_ROOT rw $CMDLINE_LINUX $SYSTEMD_OPTIONS" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux.conf"

    echo "title Arch Linux (terminal)" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-terminal.conf"
    echo "efi /vmlinuz-linux" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-terminal.conf"
    if [ -n "$SYSTEMD_MICROCODE" ]; then
        echo "initrd $SYSTEMD_MICROCODE" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-terminal.conf"
    fi
    echo "initrd /initramfs-linux.img" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-terminal.conf"
    echo "options initrd=initramfs-linux.img $CMDLINE_LINUX_ROOT rw $CMDLINE_LINUX systemd.unit=multi-user.target $SYSTEMD_OPTIONS" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-terminal.conf"

    echo "title Arch Linux (fallback)" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-fallback.conf"
    echo "efi /vmlinuz-linux" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-fallback.conf"
    if [ -n "$SYSTEMD_MICROCODE" ]; then
        echo "initrd $SYSTEMD_MICROCODE" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-fallback.conf"
    fi
    echo "initrd /initramfs-linux-fallback.img" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-fallback.conf"
    echo "options initrd=initramfs-linux-fallback.img $CMDLINE_LINUX_ROOT rw $CMDLINE_LINUX $SYSTEMD_OPTIONS" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-fallback.conf"

    if [[ $KERNELS =~ .*linux-lts.* ]]; then
        echo "title Arch Linux (lts)" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-lts.conf"
        echo "efi /vmlinuz-linux-lts" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-lts.conf"
        if [ -n "$SYSTEMD_MICROCODE" ]; then
            echo "initrd $SYSTEMD_MICROCODE" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-lts.conf"
        fi
        echo "initrd /initramfs-linux-lts.img" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-lts.conf"
        echo "options initrd=initramfs-linux-lts.img $CMDLINE_LINUX_ROOT rw $CMDLINE_LINUX $SYSTEMD_OPTIONS" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-lts.conf"

        echo "title Arch Linux (lts, terminal)" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-lts-terminal.conf"
        echo "efi /vmlinuz-linux-lts" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-lts-terminal.conf"
        if [ -n "$SYSTEMD_MICROCODE" ]; then
            echo "initrd $SYSTEMD_MICROCODE" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-lts-terminal.conf"
        fi
        echo "initrd /initramfs-linux-lts.img" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-lts-terminal.conf"
        echo "options initrd=initramfs-linux-lts.img $CMDLINE_LINUX_ROOT rw $CMDLINE_LINUX systemd.unit=multi-user.target $SYSTEMD_OPTIONS" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-lts-terminal.conf"

        echo "title Arch Linux (lts-fallback)" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-lts-fallback.conf"
        echo "efi /vmlinuz-linux-lts" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-lts-fallback.conf"
        if [ "$CPU_INTEL" == "true" -a "$VIRTUALBOX" != "true" ]; then
            echo "initrd $SYSTEMD_MICROCODE" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-lts-fallback.conf"
        fi
        echo "initrd /initramfs-linux-lts-fallback.img" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-lts-fallback.conf"
        echo "options initrd=initramfs-linux-lts-fallback.img $CMDLINE_LINUX_ROOT rw $CMDLINE_LINUX $SYSTEMD_OPTIONS" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-lts-fallback.conf"
    fi

    if [[ $KERNELS =~ .*linux-hardened.* ]]; then
        echo "title Arch Linux (hardened)" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-hardened.conf"
        echo "efi /vmlinuz-linux-hardened" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-hardened.conf"
        if [ -n "$SYSTEMD_MICROCODE" ]; then
            echo "initrd $SYSTEMD_MICROCODE" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-hardened.conf"
        fi
        echo "initrd /initramfs-linux-hardened.img" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-hardened.conf"
        echo "options initrd=initramfs-linux-hardened.img $CMDLINE_LINUX_ROOT rw $CMDLINE_LINUX $SYSTEMD_OPTIONS" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-hardened.conf"

        echo "title Arch Linux (hardened, terminal)" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-hardened-terminal.conf"
        echo "efi /vmlinuz-linux-hardened" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-hardened-terminal.conf"
        if [ -n "$SYSTEMD_MICROCODE" ]; then
            echo "initrd $SYSTEMD_MICROCODE" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-hardened-terminal.conf"
        fi
        echo "initrd /initramfs-linux-hardened.img" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-hardened-terminal.conf"
        echo "options initrd=initramfs-linux-hardened.img $CMDLINE_LINUX_ROOT rw $CMDLINE_LINUX systemd.unit=multi-user.target $SYSTEMD_OPTIONS" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-hardened-terminal.conf"

        echo "title Arch Linux (hardened-fallback)" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-hardened-fallback.conf"
        echo "efi /vmlinuz-linux-hardened" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-hardened-fallback.conf"
        if [ -n "$SYSTEMD_MICROCODE" ]; then
            echo "initrd $SYSTEMD_MICROCODE" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-hardened-fallback.conf"
        fi
        echo "initrd /initramfs-linux-hardened-fallback.img" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-hardened-fallback.conf"
        echo "options initrd=initramfs-linux-hardened-fallback.img $CMDLINE_LINUX_ROOT rw $CMDLINE_LINUX $SYSTEMD_OPTIONS" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-hardened-fallback.conf"
    fi

    if [[ $KERNELS =~ .*linux-zen.* ]]; then
        echo "title Arch Linux (zen)" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-zen.conf"
        echo "efi /vmlinuz-linux-zen" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-zen.conf"
        if [ -n "$SYSTEMD_MICROCODE" ]; then
            echo "initrd $SYSTEMD_MICROCODE" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-zen.conf"
        fi
        echo "initrd /initramfs-linux-zen.img" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-zen.conf"
        echo "options initrd=initramfs-linux-zen.img $CMDLINE_LINUX_ROOT rw $CMDLINE_LINUX $SYSTEMD_OPTIONS" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-zen.conf"

        echo "title Arch Linux (zen, terminal)" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-zen-terminal.conf"
        echo "efi /vmlinuz-linux-zen" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-zen-terminal.conf"
        if [ -n "$SYSTEMD_MICROCODE" ]; then
            echo "initrd $SYSTEMD_MICROCODE" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-zen-terminal.conf"
        fi
        echo "initrd /initramfs-linux-zen.img" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-zen-terminal.conf"
        echo "options initrd=initramfs-linux-zen.img $CMDLINE_LINUX_ROOT rw $CMDLINE_LINUX systemd.unit=multi-user.target $SYSTEMD_OPTIONS" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-zen-terminal.conf"

        echo "title Arch Linux (zen-fallback)" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-zen-fallback.conf"
        echo "efi /vmlinuz-linux-zen" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-zen-fallback.conf"
        if [ -n "$SYSTEMD_MICROCODE" ]; then
            echo "initrd $SYSTEMD_MICROCODE" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-zen-fallback.conf"
        fi
        echo "initrd /initramfs-linux-zen-fallback.img" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-zen-fallback.conf"
        echo "options initrd=initramfs-linux-zen-fallback.img $CMDLINE_LINUX_ROOT rw $CMDLINE_LINUX $SYSTEMD_OPTIONS" >> "/mnt$ESP_DIRECTORY/loader/entries/archlinux-zen-fallback.conf"
    fi

    if [ "$VIRTUALBOX" == "true" ]; then
        echo -n "\EFI\systemd\systemd-bootx64.efi" > "/mnt$ESP_DIRECTORY/startup.nsh"
    fi
}

function users() {
    print_step "users()"

    create_user $USER_NAME $USER_PASSWORD

    for U in ${ADDITIONAL_USERS[@]}; do
        IFS='=' S=(${U})
        USER=${S[0]}
        PASSWORD=${S[1]}
        create_user "${USER}" "${PASSWORD}"
    done

	arch-chroot /mnt sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
}

function create_user() {
    USER_NAME=$1
    USER_PASSWORD=$2
    arch-chroot /mnt useradd -m -G wheel,storage,optical -s /bin/bash $USER_NAME
    printf "$USER_PASSWORD\n$USER_PASSWORD" | arch-chroot /mnt passwd $USER_NAME

    pacman_install "xdg-user-dirs"
}

function desktop_environment() {
    print_step "desktop_environment()"

    PACKAGES_DRIVER=""
    PACKAGES_DDX=""
    PACKAGES_VULKAN=""
    PACKAGES_HARDWARE_ACCELERATION=""
    case "$DISPLAY_DRIVER" in
        "nvidia" )
            PACKAGES_DRIVER="nvidia"
            ;;
        "nvidia-lts" )
            PACKAGES_DRIVER="nvidia-lts"
            ;;
        "nvidia-dkms" )
            PACKAGES_DRIVER="nvidia-dkms"
            ;;
        "nvidia-390xx" )
            PACKAGES_DRIVER="nvidia-390xx"
            ;;
        "nvidia-390xx-lts" )
            PACKAGES_DRIVER="nvidia-390xx-lts"
            ;;
        "nvidia-390xx-dkms" )
            PACKAGES_DRIVER="nvidia-390xx-dkms"
            ;;
    esac
    if [ "$DISPLAY_DRIVER_DDX" == "true" ]; then
        case "$DISPLAY_DRIVER" in
            "intel" )
                PACKAGES_DDX="xf86-video-intel"
                ;;
            "amdgpu" )
                PACKAGES_DDX="xf86-video-amdgpu"
                ;;
            "ati" )
                PACKAGES_DDX="xf86-video-ati"
                ;;
            "nouveau" )
                PACKAGES_DDX="xf86-video-nouveau"
                ;;
        esac
    fi
    if [ "$VULKAN" == "true" ]; then
        case "$DISPLAY_DRIVER" in
            "intel" )
                PACKAGES_VULKAN="vulkan-icd-loader vulkan-intel"
                ;;
            "amdgpu" )
                PACKAGES_VULKAN="vulkan-icd-loader vulkan-radeon"
                ;;
            "ati" )
                PACKAGES_VULKAN=""
                ;;
            "nouveau" )
                PACKAGES_VULKAN=""
                ;;
        esac
    fi
    if [ "$DISPLAY_DRIVER_HARDWARE_ACCELERATION" == "true" ]; then
        case "$DISPLAY_DRIVER" in
            "intel" )
                PACKAGES_HARDWARE_ACCELERATION="intel-media-driver"
                if [ -n "$DISPLAY_DRIVER_HARDWARE_ACCELERATION_INTEL" ]; then
                    PACKAGES_HARDWARE_ACCELERATION=$DISPLAY_DRIVER_HARDWARE_ACCELERATION_INTEL
                fi
                ;;
            "amdgpu" )
                PACKAGES_HARDWARE_ACCELERATION="libva-mesa-driver"
                ;;
            "ati" )
                PACKAGES_HARDWARE_ACCELERATION="mesa-vdpau"
                ;;
            "nouveau" )
                PACKAGES_HARDWARE_ACCELERATION="libva-mesa-driver"
                ;;
        esac
    fi
    pacman_install "mesa $PACKAGES_DRIVER $PACKAGES_DDX $PACKAGES_VULKAN $PACKAGES_HARDWARE_ACCELERATION"

    case "$DESKTOP_ENVIRONMENT" in
        "gnome" )
            desktop_environment_gnome
            ;;
        "kde" )
            desktop_environment_kde
            ;;
        "xfce" )
            desktop_environment_xfce
            ;;
        "mate" )
            desktop_environment_mate
            ;;
        "cinnamon" )
            desktop_environment_cinnamon
            ;;
        "lxde" )
            desktop_environment_lxde
            ;;
    esac

    arch-chroot /mnt systemctl set-default graphical.target
}

function desktop_environment_gnome() {
    pacman_install "gnome gnome-extra"
    arch-chroot /mnt systemctl enable gdm.service
}

function desktop_environment_kde() {
    pacman_install "plasma-meta plasma-wayland-session kde-applications-meta"
    arch-chroot /mnt systemctl enable sddm.service
}

function desktop_environment_xfce() {
    pacman_install "xfce4 xfce4-goodies lightdm lightdm-gtk-greeter xorg-server"
    arch-chroot /mnt systemctl enable lightdm.service
}

function desktop_environment_mate() {
    pacman_install "mate mate-extra lightdm lightdm-gtk-greeter xorg-server"
    arch-chroot /mnt systemctl enable lightdm.service
}

function desktop_environment_cinnamon() {
    pacman_install "cinnamon lightdm lightdm-gtk-greeter xorg-server"
    arch-chroot /mnt systemctl enable lightdm.service
}

function desktop_environment_lxde() {
    pacman_install "lxde lxdm"
    arch-chroot /mnt systemctl enable lxdm.service
}

function packages() {
    print_step "packages()"

    if [ -n "$PACKAGES_PACMAN" ]; then
        pacman_install "$PACKAGES_PACMAN"
    fi

    if [ -n "$AUR" -o -n "$PACKAGES_AUR" ]; then
        packages_aur
    fi
}

function packages_aur() {
    arch-chroot /mnt sed -i 's/%wheel ALL=(ALL) ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers

    if [ -n "$AUR" -o -n "$PACKAGES_AUR" ]; then
        pacman_install "git"

        case "$AUR" in
            "aurman" )
                arch-chroot /mnt bash -c "echo -e \"$USER_PASSWORD\n$USER_PASSWORD\n$USER_PASSWORD\n$USER_PASSWORD\n\" | su $USER_NAME -c \"cd /home/$USER_NAME && git clone https://aur.archlinux.org/$AUR.git && gpg --recv-key 465022E743D71E39 && (cd $AUR && makepkg -si --noconfirm) && rm -rf $AUR\""
                ;;
            "yay" | *)
                arch-chroot /mnt bash -c "echo -e \"$USER_PASSWORD\n$USER_PASSWORD\n$USER_PASSWORD\n$USER_PASSWORD\n\" | su $USER_NAME -c \"cd /home/$USER_NAME && git clone https://aur.archlinux.org/$AUR.git && (cd $AUR && makepkg -si --noconfirm) && rm -rf $AUR\""
                ;;
        esac
    fi

    if [ -n "$PACKAGES_AUR" ]; then
        aur_install "$PACKAGES_AUR"
    fi

    arch-chroot /mnt sed -i 's/%wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
}

function terminate() {
    cp "$CONF_FILE" "/mnt/etc/$CONF_FILE"

    if [ "$LOG" == "true" ]; then
        mkdir -p /mnt/var/log
        cp "$LOG_FILE" "/mnt/var/log/$LOG_FILE"
    fi
}

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


function pacman_install() {
    PACKAGES=$1
    for VARIABLE in {1..5}
    do
        arch-chroot /mnt pacman -Syu --noconfirm --needed $PACKAGES
        if [ $? == 0 ]; then
            break
        else
            sleep 10
        fi
    done
}

function aur_install() {
    PACKAGES=$1
    for VARIABLE in {1..5}
    do
        arch-chroot /mnt bash -c "echo -e \"$USER_PASSWORD\n$USER_PASSWORD\n$USER_PASSWORD\n$USER_PASSWORD\n\" | su $USER_NAME -c \"$AUR -Syu --noconfirm --needed $PACKAGES\""
        if [ $? == 0 ]; then
            break
        else
            sleep 10
        fi
    done
}

function run_shconfig() {
	arch-chroot /mnt wget $REPO_URL/config.sh
	arch-chroot /mnt chmod +x /tmp/config.sh
	arch-chroot /mnt cp config.sh /tmp/config.sh
    arch-chroot /mnt /tmp/config.sh
    arch-chroot /mnt bash -c "echo -e \"$USER_PASSWORD\n$USER_PASSWORD\n$USER_PASSWORD\n$USER_PASSWORD\n\" | su $USER_NAME -c \"wget $REPO_URL/user_config.sh\""
    arch-chroot /mnt bash -c "echo -e \"$USER_PASSWORD\n$USER_PASSWORD\n$USER_PASSWORD\n$USER_PASSWORD\n\" | su $USER_NAME -c \"chmod +x user_config.sh\""
    arch-chroot /mnt bash -c "echo -e \"$USER_PASSWORD\n$USER_PASSWORD\n$USER_PASSWORD\n$USER_PASSWORD\n\" | su $USER_NAME -c \"cp user_config.sh /tmp/user_config.sh\""
    arch-chroot /mnt bash -c "echo -e \"$USER_PASSWORD\n$USER_PASSWORD\n$USER_PASSWORD\n$USER_PASSWORD\n\" | su $USER_NAME -c \"/tmp/user_config.sh\""
	
}

function print_step() {
    STEP=$1
    echo ""
    echo -e "${LIGHT_BLUE}# ${STEP} step${NC}"
    echo ""
}

function main() {
	
	get_username
	get_rootpasswd
	get_hostname
	get_userpasswd
	get_lvmpasswd
    #configuration_install
    sanitize_variables
    check_variables
    warning
    init
    facts
    check_facts
    prepare
    partition
    install
    configuration
    mkinitcpio_configuration
    kernels
    mkinitcpio
    network
    if [ "$VIRTUALBOX" == "true" ]; then
        virtualbox
    fi
    users
    bootloader
    if [ -n "$DESKTOP_ENVIRONMENT" ]; then
        desktop_environment
    fi
    packages
    run_shconfig
    terminate
    end
}

main
