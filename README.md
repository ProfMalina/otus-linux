# stands-03-lvm

Стенд для домашнего занятия "Файловые системы и LVM"

1. уменьшить том под / до 8G

Из-за файловой системы xfs использование команды lvreduce убивало виртуалку, выдерживало уменьшение до 20G без проблем, дальше смерть, пришлось переносить все данные на другой диск, уменьшать этот, а потом возвращать обратно

`sudo yum install xfsdump -y`

`sudo pvcreate /dev/sdb`

`sudo vgcreate vg_tmp_root /dev/sdb`

`sudo lvcreate -n lv_tmp_root -l +100%FREE /dev/vg_tmp_root`

`sudo mkfs.xfs /dev/vg_tmp_root/lv_tmp_root`

`sudo mount /dev/vg_tmp_root/lv_tmp_root /mnt`

`sudo xfsdump -J - /dev/VolGroup00/LogVol00 | sudo xfsrestore -J - /mnt`

`for i in /proc/ /sys/ /dev/ /run/ /boot/; do sudo mount --bind $i /mnt/$i; done`

`sudo chroot /mnt/`

`sudo grub2-mkconfig -o /boot/grub2/grub.cfg`

`cd /boot ; for i in `ls initramfs-*img`; do dracut -v $i `echo $i|sed "s/initramfs-//g; s/.img//g"` --force; done`

`sudo vi /boot/grub2/grub.cfg`

```
cat /boot/grub2/grub.cfg | grep vg_tmp_root/lv_tmp_root
        linux16 /vmlinuz-3.10.0-862.2.3.el7.x86_64 root=/dev/mapper/vg_tmp_root-lv_tmp_root ro no_timer_check console=tty0 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 elevator=noop crashkernel=auto rd.lvm.lv=vg_tmp_root/lv_tmp_root rd.lvm.lv=VolGroup00/LogVol01 rhgb quiet 
```
`exit`

`sudo reboot`

`sudo lvreduce -L 8G /dev/mapper/VolGroup00-LogVol00`

`sudo mkfs.xfs /dev/VolGroup00/LogVol00 -f`

`sudo mount /dev/VolGroup00/LogVol00 /mnt`

`sudo xfsdump -J - /dev/vg_tmp_root/lv_tmp_root | sudo xfsrestore -J - /mnt`

`for i in /proc/ /sys/ /dev/ /run/ /boot/; do sudo mount --bind $i /mnt/$i; done`

`sudo chroot /mnt/`

`sudo grub2-mkconfig -o /boot/grub2/grub.cfg`

`cd /boot ; for i in `ls initramfs-*img`; do dracut -v $i `echo $i|sed "s/initramfs-//g; s/.img//g"` --force; done`

`exit`

`sudo reboot`

`sudo lvremove /dev/vg_tmp_root/lv_tmp_root`

2. выделить том под /home

`sudo -i`

`lvcreate -n LogVol_Home -L 2G /dev/VolGroup00`

`mkfs.xfs /dev/VolGroup00/LogVol_Home`

`mount /dev/VolGroup00/LogVol_Home /mnt/`

`cp -aR /home/* /mnt/`

`rm -rf /home/*`

`umount /mnt`

`mount /dev/VolGroup00/LogVol_Home /home/`

`echo "`blkid | grep Home | awk '{print $2}'` /home xfs defaults 0 0" >> /etc/fstab`

3. выделить том под /var (/var -  сделать в mirror)

`pvcreate /dev/sdc /dev/sdd`

`vgcreate vg_var /dev/sdc /dev/sdd`

`lvcreate -L 950M -m1 -n lv_var vg_var`

`mkfs.ext4 /dev/vg_var/lv_var`

`mount /dev/vg_var/lv_var /mnt`

`cp -aR /var/* /mnt/ # rsync -avHPSAX /var/ /mnt/`

`umount /mnt`

`mount /dev/vg_var/lv_var /var`

`echo "`blkid | grep var: | awk '{print $2}'` /var ext4 defaults 0 0" >> /etc/fstab`

4. для /home - сделать том для снэпшотов

`lvcreate -n LogVol_SnapHome -L 2G /dev/VolGroup00`

5. прописать монтирование в fstab (попробовать с разными опциями и разными файловыми системами на выбор)

`echo "`blkid | grep Home | awk '{print $2}'` /home xfs defaults 0 0" >> /etc/fstab`

`echo "`blkid | grep var: | awk '{print $2}'` /var ext4 defaults 0 0" >> /etc/fstab`

6. Работа со снапшотами:
  - сгенерировать файлы в /home/

`cd /`

`sudo touch /home/file{1..20}`

  - снять снэпшот

`sudo lvcreate -L 100MB -s -n home_snap /dev/VolGroup00/LogVol_Home`

  - удалить часть файлов

`sudo rm -f /home/file*`

  - восстановиться со снэпшота

`sudo umount /home`

`sudo lvconvert --merge /dev/VolGroup00/home_snap`

`sudo mount /home`

![proof](https://user-images.githubusercontent.com/10125092/119709380-d0dc3980-be65-11eb-964e-61cbf12cb297.PNG)

# zfs

 - Установка

```
sudo yum install -y yum-utils
sudo yum -y install http://download.zfsonlinux.org/epel/zfs-release.el7_5.noarch.rpm
gpg --quiet --with-fingerprint /etc/pki/rpm-gpg/RPM-GPG-KEY-zfsonlinux
sudo yum-config-manager --enable zfs-kmod
sudo yum-config-manager --disable zfs
sudo yum install -y zfs
sudo modprobe zfs
```

 

`sudo -i`

 - Разбил диск на 1G и 9G

`fdisk /dev/sdb`

 - Создание пула

`zpool create -f pool1 mirror /dev/sdb1 /dev/sde`

 - Кеш или кэш

`zpool add pool1 cache /dev/sdb2`

```
[root@lvm ~]# zpool status
  pool: pool1
 state: ONLINE
  scan: none requested
config:

        NAME        STATE     READ WRITE CKSUM
        pool1       ONLINE       0     0     0
          mirror-0  ONLINE       0     0     0
            sdb1    ONLINE       0     0     0
            sde     ONLINE       0     0     0
        cache
          sdb2      ONLINE       0     0     0

errors: No known data errors
```

 - Снапшот

`zfs snapshot pool1@testsnap`

 ```
[root@lvm ~]# zfs list -t snapshot
NAME             USED  AVAIL  REFER  MOUNTPOINT
pool1@testsnap     0B      -    24K  -
 ```

 - Монтирование в /opt

`zfs set mountpoint=/opt pool1`

```
[root@lvm ~]# df -T
Filesystem                         Type     1K-blocks    Used Available Use% Mounted on
/dev/mapper/VolGroup00-LogVol00    xfs        8378368 2668008   5710360  32% /
devtmpfs                           devtmpfs    111876       0    111876   0% /dev
tmpfs                              tmpfs       120692       0    120692   0% /dev/shm
tmpfs                              tmpfs       120692    4652    116040   4% /run
tmpfs                              tmpfs       120692       0    120692   0% /sys/fs/cgroup
/dev/sda2                          xfs        1038336   62216    976120   6% /boot
/dev/mapper/vg_var-lv_var          ext4        943128  162240    715764  19% /var
tmpfs                              tmpfs        24140       0     24140   0% /run/user/1000
/dev/mapper/VolGroup00-LogVol_Home xfs        2086912   33004   2053908   2% /home
pool1                              zfs         900992       0    900992   0% /opt
```
