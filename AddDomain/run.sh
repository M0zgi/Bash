#!/bin/bash

echo 'Script add new site v0.1'
echo 'To Do:'
echo '1. Use Apache service'
echo '2. Use Nginx service'
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
1) ./class/script/new_site/add_site_apache.sh;;
2) ./class/script/new_site/add_site_nginx.sh;;
esac
