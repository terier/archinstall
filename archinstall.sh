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

##### BEGIN SCRIPT #####

loadkeys slovene
timedatectl set-ntp-true

echo "-----> Select disk"
disks=$(lsblk -nlp | cut -d ' ' -f 1)
disk=$(force $disks)

partitions=$disk*

echo "-----> Create partitions"
#fdisk $disk

echo "-----> Setup partitions"
echo "Root partition:"
root=$(force $partitions)
echo "Swap partition:"
swap=$(force $partitions)
echo "Boot partition (or 0):"
boot=$(choose $partitions)
echo "Home partition (or 0):"
home=$(choose $partitions)

[[ ! -z $root ]] && {
    echo "Format root?"
    [[ $(yesno) = "yes" ]] && {
        echo "Choose filesystem:"
        type=$(force "btrfs ext4")
        mkfs -t $type $root
    }
}

[[ ! -z $boot ]] && {
    echo "Format boot?"
    [[ $(yesno) = "yes" ]] && {
        echo "Choose filesystem:"
        type=$(force "btrfs ext4")
        mkfs -t $type $boot
    }
}

[[ ! -z $home ]] && {
    echo "Format home?"
    [[ $(yesno) = "yes" ]] && {
        echo "Choose filesystem:"
        type=$(force "btrfs ext4")
        mkfs -t $type $home
    }
}

[[ ! -z $swap ]] && mkswap $swap

echo "-----> Mount partitions"
[[ ! -z $root ]] && mount $root /mnt
[[ ! -z $boot ]] && mount $boot /mnt/boot
[[ ! -z $home ]] && mount $root /mnt/home
[[ ! -z $swap ]] && swapon $root
genfstab -U /mnt >> /mnt/etc/fstab

echo "-----> Select mirrors and install packages"
nano /etc/pacman.d/mirrorlist
pacstrap /mnt base base-devel btrfs-progs

echo "-----> Copy configuration files"
cp -r installconfigs /mnt/etc

echo "-----> Chroot and configure system"
arch-chroot /mnt /mnt/etc/installconfigs/chrootinstall.sh

echo "-----> Remove configuration files and unmount"
rm -rf /mnt/etc/installconfigs
umount -R /mnt

echo "-----> Change stuff, then EOF to reboot"
/bin/bash
reboot
