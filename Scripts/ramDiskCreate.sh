#!/bin/bash

# Инициализация переменных настойки

# Имя диска
DiskName=MyRAMDisk

# Маркерная папка
Marker=/Volumes/$DiskName/RamMount

# Создание RAM диска
if ! [ -d $Marker ]; then
	diskutil erasevolume HFS+ $DiskName `hdiutil attach -nomount ram://7900000`
	chmod 777 /Volumes/$DiskName
	mkdir $Marker
	chmod 111 $Marker
fi
