#!/bin/bash

# Инициализация переменных настойки

# Имя диска
DiskName=MyRAMDisk

# Имя пользователя
name=$(whoami)

# Путь к кешу в профиле
Cashes=/Users/$name/Library/Caches/

# Путь к библитеке в профиле
LibraryDir=/Users/$name/Library/

# Путь к свойствам в профиле
PreferencesDir=$LibraryDir'Preferences/'

# Путь к Application Support в профиле
#AppSupDir=$LibraryDir'Application Support/' Почему-то не работает

# Имена кеша
declare -a CasheNames
CasheNames+=(com.operasoftware.Opera)
CasheNames+=(Firefox)
CasheNames+=(Mozilla)
CasheNames+=(com.apple.Safari)
CasheNames+=(com.apple.Safari.SearchHelper)
CasheNames+=(com.apple.helpd)
CasheNames+=(com.apple.iTunes)
CasheNames+=(GeoServices)
CasheNames+=(com.operasoftware.Installer.Opera)
CasheNames+=(Adobe)
CasheNames+=(Microsoft)
CasheNames+=(com.apple.installer)
CasheNames+=(com.bittorrent.BitTorrent)
CasheNames+=(TemporaryItems)

# Разделитель
separator=@

# Массив строк с эмуляцией структуры
# каждая строка должна иметь разделитель
# до разделителя - Имя папки на RAM диске
# после разделителя - Имя папки на системном диске
declare -a PreferencesNames
PreferencesNames+=(Macromedia@$PreferencesDir'Macromedia/Flash Player/#SharedObjects')
PreferencesNames+=(AdobeCameraRaw@$Cashes'Adobe Camera Raw')
PreferencesNames+=(MacromediaOpera@$LibraryDir'Application Support/com.operasoftware.Opera/Pepper Data/Shockwave Flash/WritableRoot/#SharedObjects')
PreferencesNames+=(MacromediaVivaldi@$LibraryDir'Application Support/Vivaldi/Default/Pepper Data/Shockwave Flash')

# Путь к кешу на RAM диске
RAMCashes=/Volumes/$DiskName/$name/Cashes/

# Путь к свойствам на RAM диске
RAMPreferences=/Volumes/$DiskName/$name/Preferences/

# Маркерная папка
Marker=/Volumes/$DiskName/RamMount

# Создание ссылок
if ! [ -d $RAMCashes ]; then
	mkdir -p $RAMCashes
	mkdir -p $RAMPreferences

	# Обходим имена кеша
	for (( i = 0; i<${#CasheNames[@]}; i++ )); do
		# Создаем папки на RAM диске
		mkdir $RAMCashes${CasheNames[$i]}
		# Удаляем папки в профиле
		rm -f -r -d $Cashes${CasheNames[$i]}
		# Создаем в профиле символьную ссылку на папку на RAM диске
		ln -s $RAMCashes${CasheNames[$i]} $Cashes${CasheNames[$i]} 
	done

	# Обходим папки в свойствах
	for (( i = 0; i<${#PreferencesNames[@]}; i++ )); do
		posision=0
		str=${PreferencesNames[i]}
		for (( index = 0; index<${#str}; index++ )); do
			st=${str:$index:1}
			if [[ $st == $separator ]]; then
				posision=$index
				break
			fi
		done
		# Имя папки на RAM диске
		ramdir=${str:0:$posision}
		# Имя папки на системном диске
		let "posision1=$posision+1"
		profiledir="${str:$posision1}"
		# Создаем папки на RAM диске
		mkdir $RAMPreferences$ramdir
		# Удаляем папки в профиле
		rm -f -r -d "$profiledir"
		# Создаем в профиле символьную ссылку на папку на RAM диске
		ln -s $RAMPreferences$ramdir "$profiledir"
	done
fi

