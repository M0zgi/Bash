#!/bin/bash

echo 'Script Process management v0.1'
echo 'To Do:'
echo '1. Search process'
echo '2. Kill process (-9)'
echo '0. Exit'

#Обрабатываем пользовательский ввод
read -n 1 -p '#: ' ans
echo ''
#проверка на 0
if [ ${ans} -eq 0 ];
  then exit;
fi

#запуск скриптов согласно выбору пользователя
case "$ans" in
1) ./class/script/pid/search.sh;;
2) ./class/script/pid/kill.sh;;
esac