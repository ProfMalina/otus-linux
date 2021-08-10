#!/bin/bash


sudo -i
lsblk

sfdisk -d /dev/sda | sfdisk /dev/sdb

fdisk /dev/sdb

# mdadm --create /dev/md0 -l1 -n2 missing /dev/sdb1
mdadm --create /dev/md0 --metadata=1.2 -l1 -n2 missing /dev/sdb1

mkfs.ext4 /dev/md0

mount /dev/md0 /mnt

rsync -avvx --delete / /mnt

blkid /dev/sdb1
0c3948d1-25ed-5653-e71c-245512a67895

# blkid /dev/md0
# 89d73e09-78c6-42b9-920e-84ee36c8907e

vi /mnt/etc/fstab

mkdir -p /mnt/etc/mdadm/

mdadm --detail --scan > /mnt/etc/mdadm/mdadm.conf

mount --bind /dev /mnt/dev
mount --bind /sys /mnt/sys
mount --bind /proc /mnt/proc

chroot /mnt/

vi /boot/grub2/device.map

grub2-mkconfig -o /boot/grub2/grub.cfg
# grub2-install /dev/sdb

cd /boot ; for i in `ls initramfs-*img`; do dracut -v $i `echo $i|sed "s/initramfs-//g; s/.img//g"` --force; done

# vi /boot/grub2/device.map

# update-grub

vi /boot/grub2/grub.cfg

reboot


загрузился с диска /dev/md0






yum install xfsdump -y
# yum install lvm2
# df -T
lsblk
# fdisk -l
wipefs -a /dev/sdb

fdisk /dev/sdb
# parted /dev/sdb
# mklabel gpt

# sgdisk -n 1:0:+500 /dev/sdb
# sgdisk -n 0:+40460 /dev/sdb


mkfs.xfs /dev/sdb1

blkid

mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 missing /dev/sdb2

mkfs.xfs /dev/md0

mount /dev/md0 /mnt

xfsdump -J - /dev/sda1 | xfsrestore -J - /mnt

for i in /proc/ /sys/ /dev/ /run/ /boot/; do sudo mount --bind $i /mnt/$i; done


sudo chroot /mnt/

sudo grub2-mkconfig -o /boot/grub2/grub.cfg

cd /boot ; for i in `ls initramfs-*img`; do dracut -v $i `echo $i|sed "s/initramfs-//g; s/.img//g"` --force; done

sudo vi /boot/grub2/grub.cfg

# sfdisk -d /dev/sda | sfdisk -f /dev/md0

# mkfs.xfs /dev/md0 -f

# mkdir /mnt/new
# mkdir /mnt/old

mount /dev/md0 /mnt
mkfs.ext4 /dev/sdb1
mkdir /mnt/newboot
mount /dev/sdb1 /mnt/newboot
# mount /dev/sda1 /mnt/old
# rsync -av /boot/ /mnt/newboot/
xfsdump -J - /dev/sda1 | xfsrestore -J - /mnt
grub2-install /dev/sdb1
grub2-mkconfig -o /mnt/newboot/grub2/grub.cfg
# rsync -av /mnt/old/ /mnt/new/

# yum search grub-install

grub2-mkconfig -o /mnt/newboot/grub2/grub.cfg
grub2-mkconfig -o /mnt/boot/grub2/grub.cfg
for i in /proc/ /sys/ /dev/ /run/ /boot/; do sudo mount --bind $i /mnt$i; done
chroot /mnt/new/

mount /dev/md0p1 /boot
mdadm -a /dev/md0 /dev/sda1



blkid
sudo yum install nano -y
nano /etc/fstab
reboot

for i in /proc/ /sys/ /dev/ /run/ /boot/; do sudo mount --bind $i /mnt$i; done
sudo chroot /mnt/



grub2-install /dev/sdb2


sudo grub2-mkconfig -o /boot/grub2/grub.cfg


reboot

umount /dev/sdb1


mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
mdadm --examine --scan >> /etc/mdadm/mdadm.conf

mdadm -a /dev/md0 /dev/sdb1


mount /dev/md0 /mnt/
rsync --progress -av /boot/ /mnt/
umount /boot
mount /dev/md0 /boot
mdadm -a /dev/md0 /dev/sda1
pvcreate /dev/md1
vgextend vg0 /dev/md1
pvmove /dev/sda5 /dev/md1
vgreduce vg0 /dev/sda5
mdadm -a /dev/md1 /dev/sda5
cat /proc/mdstat

mdadm --examine --scan >> /etc/mdadm/mdadm.conf

update-grub
grub-install /dev/sdb
grub-install /dev/sda
