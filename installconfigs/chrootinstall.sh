#!/bin/bash

# force list
function force {
    select var in $@; do
        [[ ! -z $var ]] && { echo $var; break; }
    done
}

# choose list
function choose {
    select var in $@; do echo $var; break; done
}

# yesno
function yesno {
    force "yes no"
}

# timezone
ln -s /usr/share/zoneinfo/Europe/Ljubljana /etc/localtime
hwclock --systohc --utc

# locale
localectl set-keymap slovene
loadkeys slovene
nano /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo KEYMAP=slovene > /etc/vconsole.conf
echo FONT=lat9w-16 >> /etc/vconsole.conf

# hostname
while [[ -z $hostname ]]; do
    read -p "Hostname: " hostname
done
echo $hostname > /etc/hostname
nano /etc/hosts

# network
echo "Install wifi-menu (dialog)?"
[[ $(yesno) = "yes" ]] && pacman -S dialog

# packages
pacman -S git bc htop figlet archey3 unzip alsa-utils xorg xorg-server rxvt-unicode i3 slock dmenu feh scrot pcmanfm lxappearance ttf-dejavu xf86-input-synaptics epdfview yajl expac
echo "Install graphics?"
[[ $(yesno) = "yes" ]] && pacman -S gimp inkscape blender
echo "Install audio?"
[[ $(yesno) = "yes" ]] && pacman -S jack qjackctl qsynth a2jmidid patchage musescore audacity ardour audacious
echo "Install extra audio?"
[[ $(yesno) = "yes" ]] && pacman -S qtractor hydrogen rosegarden lmms guitarix2 calf ladspa dssi

# pacaur
git clone https://aur.archlinux.org/cower.git
cd cower
gpg --recv-keys --keyserver hkp://pgp.mit.edu 1EB2638FF56C0C53
makepkg -si
cd ..
rm -rf cower
git clone https://aur.archlinux.org/pacaur.git
cd pacaur
makepkg -si
cd ..
rm -rf pacaur

# AUR packages
pacaur -S google-chrome sublime-text-dev paper-gtk-theme-git paper-icon-theme-git

# users
echo "Root password"
passwd
while [[ -z $username ]]; do
    read -p "Username: " username
done
useradd -m -g users -G wheel,audio -s /bin/bash $username
passwd $username
home=/home/$username
cp /etc/.xinitrc $home/.xinitrc
cp /etc/.nanorc $home/.nanorc
cp /etc/.bashrc $home/.bashrc
cp /etc/.gitconfig $home/.gitconfig
cp /etc/.Xresources $home/.Xresources
ln -s $home/.Xresources $home/.Xdefaults
cp /etc/clock.sh $home/clock.sh
cp /etc/initi3.sh $home/initi3.sh

# other stuff
setxkbmap si

# GRUB
echo "Using intel processor?"
[[ $(yesno) = "yes" ]] && pacman -S intel-ucode
pacman -S grub

echo "Select disk for GRUB"
disks=$(lsblk -nlp | cut -d ' ' -f 1)
disk=$(force $disks)
grub-install --target=i386-pc $disk
grub-mkconfig -o /boot/grub/grub.cfg

# other
echo "Any other changes, go ahead"
/bin/bash

# end
echo "Exiting chroot"
