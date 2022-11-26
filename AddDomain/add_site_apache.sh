#!/bin/bash
GREEN='\033[0;92m'
RED='\033[0;91m'
NC='\033[0m'

Info() {
  echo -en "[${1}] ${GREEN}${2}${NC}\n"
}

Error() {
  echo -en "[${1}] ${RED}${2}${NC}\n"
}

read -p "Enter domain name: " domain
    if [ -z $domain ]
      then
      Error "Error" "Domain name can't be empty"
     else
     echo "<VirtualHost *:8080>
        ServerName $domain

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/$domain
        ErrorLog \${APACHE_LOG_DIR}/$domain-error.log
        CustomLog \${APACHE_LOG_DIR}/$domain-access.log combined

        <Directory /var/www/$domain/>
                Options -Indexes +Followsymlinks
                DirectoryIndex index.html
                require all granted
        </Directory>
        </VirtualHost>">/etc/apache2/sites-available/$domain.conf

        mkdir -p /var/www/$domain
        chown www-data:www-data /var/www/$domain/
        sudo a2ensite $domain.conf > /dev/null
        sudo systemctl reload apache2
        echo "New site $domain add" > /var/www/$domain/index.html
        Info "Info" "New site $domain add"
    fi