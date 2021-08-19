# Определить алгоритм с наилучшим сжатием

`vagrant ssh server`

`sudo -i`

`lsblk`

`zpool create storage sdb sdc sdd sde`

`zfs create storage/gzip`

`zfs create storage/gzip-1`

`zfs create storage/gzip-2`

`zfs create storage/gzip-3`

`zfs create storage/gzip-4`

`zfs create storage/gzip-5`

`zfs create storage/gzip-6`

`zfs create storage/gzip-7`

`zfs create storage/gzip-8`

`zfs create storage/gzip-9`

`zfs create storage/zle`

`zfs create storage/lzjb`

`zfs create storage/lz4`

`zfs set compress=gzip storage/gzip`

`zfs set compress=gzip-1 storage/gzip-1`

`zfs set compress=gzip-2 storage/gzip-2`

`zfs set compress=gzip-3 storage/gzip-3`

`zfs set compress=gzip-4 storage/gzip-4`

`zfs set compress=gzip-5 storage/gzip-5`

`zfs set compress=gzip-6 storage/gzip-6`

`zfs set compress=gzip-7 storage/gzip-7`

`zfs set compress=gzip-8 storage/gzip-8`

`zfs set compress=gzip-9 storage/gzip-9`

`zfs set compress=lz4 storage/lz4`

`zfs set compress=lzjb storage/lzjb`

`zfs set compress=zle storage/zle`

`yum install -y wget`

`wget -O War_and_Peace.txt https://gutenberg.org/files/2600/2600-0.txt`

`for i in /storage/*; do cp War_and_Peace.txt $i/; done`

`zfs get compression,compressratio`

![compress](https://user-images.githubusercontent.com/10125092/119886430-a2c92900-bf3b-11eb-99fc-7d9de20a1353.PNG)

# Определить настройки pool’a

Файл скачен через браузер и закинут по scp

`scp zfs_task1.tar.gz vagrant@10.0.0.41:~/`

`cp /home/vagrant/zfs_task1.tar.gz ~/zfs_task1.tar.gz`

`tar -xvf zfs_task1.tar.gz`

`zpool import -d ${PWD}/zpoolexport/`

`zpool import -d ${PWD}/zpoolexport/ otus`

`zpool list`
```
[root@server ~]# zpool list
NAME      SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
otus      480M  2.21M   478M        -         -     0%     0%  1.00x    ONLINE  -
storage  3.75G  20.8M  3.73G        -         -     0%     0%  1.00x    ONLINE  -
```
Командами zfs определить настройки

`zfs get all otus`
`zpool list`
`zpool status otus`

-	размер хранилища

`480M`

-	тип pool

` mirror-0`

-	значение recordsize

`zfs get recordsize`

```
otus            recordsize  128K     local
otus/hometask2  recordsize  128K     inherited from otus
```

-	какое сжатие используется

`zfs get compression,compressratio`

```
otus            compression    zle       local
otus            compressratio  1.00x     -
otus/hometask2  compression    zle       inherited from otus
otus/hometask2  compressratio  1.00x     -
```

-	какая контрольная сумма используется 

`zfs get checksum`

```
otus            checksum  sha256     local
otus/hometask2  checksum  sha256     inherited from otus
```

# Найти сообщение от преподавателей

 - Скопировал через scp `scp otus_task2.file vagrant@10.0.0.41:~/`

`cp /home/vagrant/otus_task2.file ~/otus_task2.file`
`zpool create task2 sdf sdg`
`zfs create task2/data`
`zfs receive task2/data/test < otus_task2.file`
`zfs list -t snapshot`

```
NAME                    USED  AVAIL     REFER  MOUNTPOINT
task2/data/test@task2     0B      -     3.69M  -
```

`zfs rollback task2/data/test@task2`
`find ./ -name secret_message`

```
[root@server storage]# find / -name secret_message
/task2/data/test/task1/file_mess/secret_message
```

`cat /task2/data/test/task1/file_mess/secret_message`

```
https://github.com/sindresorhus/awesome
```
