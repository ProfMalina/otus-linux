#!/bin/bash

for disk in /dev/sd[b-g] ; do wipefs -a $disk ; done
mdadm --zero-superblock /dev/sd[b-g]
mdadm --create --verbose /dev/md1 --level=5 --raid-devices=4 /dev/sdb /dev/sdc /dev/sdd /dev/sde

mkdir /etc/mdadm
echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
cat /etc/mdadm/mdadm.conf

# mdadm /dev/md1 --fail /dev/sdb
# mdadm --add /dev/md1 /dev/sdf
# mdadm --detail /dev/md1
# mdadm /dev/md1 --remove /dev/sdb

parted -s /dev/md1 mklabel gpt
for i in {1..5} ; do sgdisk -n ${i}:0:+50m /dev/md1 ; done
for i in {1..5} ; do mkfs.ext4 /dev/md1p$i ; done
for i in {1..5} ; do mkdir /mnt/folder$i ; done
for i in {1..5} ; do mount /dev/md1p$i /mnt/folder$i ; done
for i in {1..5} ; do echo /dev/md1p$i /mnt/folder$i ext4 defaults 1 2 >> /etc/fstab; done

df -h
