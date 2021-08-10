# HW1

 - Установил Packer (vagrant и vmbox установлены до занятий)

```
curl https://releases.hashicorp.com/packer/1.4.4/packer_1.4.4_linux_amd64.zip | sudo gzip -d > /usr/local/bin/packer && sudo chmod +x /usr/local/bin/packer
echo "export PATH=/usr/local/bin/packer:$PATH" >> ~/.bashrc
```

 - Создал собственный репозиторий и втеку под ДЗ, скачал туда содержимое `https://github.com/dmitry-lyutenko/manual_kernel_update`

```
git init
git remote add origin git@github.com:ProfMalina/otus-linux.git
git branch -M main
git add .
git commit -m "initial"
git push --set-upstream origrn main
git checkout -b 01_manual_kernel_update
```

 - Выполнил действия согласно заданию

```
vagrant up
vagrant ssh
sudo yum install -y http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
sudo yum --enablerepo elrepo-kernel install kernel-ml -y
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
sudo grub2-set-default 0
sudo reboot
vagrant ssh
```

 - После перезапуска проверил успешность выполненых действий

```
uname -r
exit
```

 - Собрал образ

```
cd packer
packer build centos.json
```

 - Провёл тестирование

```
vagrant box add --name centos-7-5 centos-7.7.1908-kernel-5-x86_64-Minimal.box
vagrant box list
mkdir ../test
cd ../test
vagrant init centos-7-5
vagrant up
vagrant ssh
uname -r  # 5.13.7-1.el7.elrepo.x86_64
exit
vagrant box remove -f centos-7-5
vagrant destroy -f
```

 - Опубликовал свой образ, изменил его приватность на видимый `https://app.vagrantup.com/ProfMalina/boxes/centos-7-5`

```
cd ../packer
vagrant cloud auth login # You are now logged in.
vagrant cloud publish -f --release ProfMalina/centos-7-5 1.0 virtualbox centos-7.7.1908-kernel-5-x86_64-Minimal.box
```

 - Добавил свой образ в Vagrantfile и проверил работоспособность

 :box_name => "ProfMalina/centos-7-5",

```
cd ..
vagrant up
vagrant ssh
uname -r
exit
vagrant destroy -f
```

$ HW1*
- Обновление gcc до версии выше 4.90

- Сборка ядра из исходников

```
sudo -i
yum update -y
yum install -y ncurses-devel make gcc bc bison flex elfutils-libelf-devel openssl-devel grub2 wget

yum groupinstall -y "Development Tools"
yum install -y centos-release-scl
yum install -y devtoolset-7
scl enable devtoolset-7 bash
gcc --version

cd /usr/src/
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.13.7.tar.xz
tar -xvf linux-5.13.7.tar.xz 
cd linux-5.13.7
cp -v /boot/config-3.10.0-1127.el7.x86_64 /usr/src/linux-5.13.7/.config
make menuconfig
make bzImage
make modules
make modules_install
make
make install
grub2-mkconfig -o /boot/grub2/grub.cfg
grub2-set-default 0
reboot
vagrant ssh 
uname -r # 5.13.7
```

# shared_folders

- изменил `config.vm.synced_folder ".", "/vagrant", disabled: true` на `config.vm.synced_folder ".", "/vagrant", type: "rsync"` и заработало
