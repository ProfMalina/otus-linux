## HW 7

# Сброс пароля
 - При загрузке нажимаем `e`
 - Редактируем строку начинающуюся на `linux16` убираем параметры `console` и добавляем `rd.break`
 - ctrl+x

`mount -o remount,rw /sysroot`

`chroot /sysroot`

`passwd`

`passwd vagrant`

`touch /.autorelabel`

`exit`

`mount -o remount,ro /sysroot`

# Сброс пароля 2
 - При загрузке нажимаем `e`
 - Редактируем строку начинающуюся на `linux16` убираем параметры `console` и добавляем `init=/bin/sh`
 - ctrl+x

`mount -o remount,rw /`

`passwd`

`passwd vagrant`

`vi /etc/selinux/config` меняем `SELINUX=enforcing` на `disabled`

# Установить систему с LVM, после чего переименовать VG

 - `sudo -i`

 - `lvmdiskscan`

 - `vgs`

 - `vgrename centos mynewname`

 - `ls -l /dev/mapper`

```
[root@system-boot ~]# ls -l /dev/mapper
итого 0
crw-------. 1 root root 10, 236 сен  8 06:50 control
lrwxrwxrwx. 1 root root       7 сен  8 06:55 mynewname-home -> ../dm-2
lrwxrwxrwx. 1 root root       7 сен  8 06:55 mynewname-root -> ../dm-0
lrwxrwxrwx. 1 root root       7 сен  8 06:55 mynewname-swap -> ../dm-1
```

 - `vi /etc/default/grub` меняем названия

 - `vi /boot/grub2/grub.cfg` меняем название в разделе `linux16`

 - `vi /etc/fstab` меняем названия

 - `mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)`

 - `reboot`

 - `sudo lvs`

```
[vagrant@system-boot ~]$ sudo lvs
  LV   VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  home mynewname -wi-ao---- <72,12g                                                    
  root mynewname -wi-ao----  50,00g                                                    
  swap mynewname -wi-ao----  <3,88g 
```

# Добавить модуль в initrd

 - `sudo -i`

 - `mkdir /usr/lib/dracut/modules.d/01mymodule`

 - `cd /usr/lib/dracut/modules.d/01mymodule`

 - `touch module-setup.sh drakut-test.sh`

 - `chmod +x module-setup.sh drakut-test.sh`

 - Содержимое скриптов в репе

 - `mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)`

 - `lsinitrd -m /boot/initramfs-$(uname -r).img | grep mymodule`

 - `reboot`

 - `cat /var/log/messages | grep "dracut module"`

 ```
Sep  8 07:47:33 system-boot dracut-pre-pivot: < I'm dracut module >
 ```
