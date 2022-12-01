#!/bin/bash

volume=(
%{ for volume in params ~}
${volume}
%{ endfor ~}
)

i=0

sudo apt-get update
sudo apt-get install -y curl




# Modify /etc/fstab to mount the volume after restarting the virtual machine
sudo bash -c "cat << EOM > /etc/fstab_new
# /etc/fstab
# Modified by FIWARE Lab Admin on $(date)
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'.
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info.
#
# After editing this file, run 'systemctl daemon-reload' to update systemd
# units generated from this file.
#
# <file system>    <mount point>    <filesystem type>    <mount options>    <dumped?>    <fsck order>

EOM"

sudo bash -c "cat /etc/fstab >> /etc/fstab_new"




while [ $i -lt $${#volume[@]} ]
do
    # Initialize the variables of the disks
    disk=$${volume[$i]}
    mount=$${volume[$i]}"1"

    # Create the partition table of the volume
    echo "n
    p
    1


    w
    " | sudo fdisk $${disk}

    # Create a ext3 file system in the new partition
    sudo mkfs -t ext3 $${mount}

    # Mount the volume
    sudo mkdir /data
    sudo mount $${mount} /data

    sudo bash -c "cat << EOM >> /etc/fstab_new

    $${mount}          /data            ext3                 defaults            0           0

    EOM"

    # Increment the i = i + 1
    i=`expr $i + 1`
done



sudo bash -c "mv /etc/fstab_new /etc/fstab"
