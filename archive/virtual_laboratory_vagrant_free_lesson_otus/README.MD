# Vagrant команды

```
init
status
up
halt/suspend
resume
reload
destroy -f
config-ssh
box
ssh
```

# Создать вагрант файл

`vagrant init centos/7`

# Плагины

`vagrant plugin install <plugin_name>`

`sahara` снэпшоты

`vagrant-scp` упрощает scp

`vagrant-hostupdater` добавляет записи в hosts

`vagrant-share` делаться своим окружением

# synced_folder

Работает с помощью rsync

`config.vm.synced_folder "src/", "/srv/website"`

