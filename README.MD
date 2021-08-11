# HW2

Добавил еще 2 диска в Vagrantfile

Добавил скрипт который создает raid5

Поднял vm для поломки и починки raid(комманды закоммичены в скрипте)

Добавил в скрипт разбивку и монтирование

```
    otuslinux: Filesystem      Size  Used Avail Use% Mounted on
    otuslinux: devtmpfs        489M     0  489M   0% /dev
    otuslinux: tmpfs           496M     0  496M   0% /dev/shm
    otuslinux: tmpfs           496M  6.7M  489M   2% /run
    otuslinux: tmpfs           496M     0  496M   0% /sys/fs/cgroup
    otuslinux: /dev/sdg1        40G  6.4G   34G  16% /
    otuslinux: tmpfs           100M     0  100M   0% /run/user/1000
    otuslinux: /dev/md1p1       45M  1.1M   40M   3% /mnt/folder1
    otuslinux: /dev/md1p2       45M  1.1M   40M   3% /mnt/folder2
    otuslinux: /dev/md1p3       45M  1.1M   40M   3% /mnt/folder3
    otuslinux: /dev/md1p4       45M  1.1M   40M   3% /mnt/folder4
    otuslinux: /dev/md1p5       45M  1.1M   40M   3% /mnt/folder5
```

# HW with **

 - перенос с одного диска в RAID

```
[root@otuslinux ~]# lsblk
NAME   MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
sda      8:0    0  40G  0 disk 
sdb      8:16   0  40G  0 disk 
`-sdb1   8:17   0  40G  0 part /
```