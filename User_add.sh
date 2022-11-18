#!/bin/bash

SCRIPT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
BACKUPS=$SCRIPT_PATH/backups


GREEN='\033[0;92m'
RED='\033[0;91m'
NC='\033[0m'

Info() {
  echo -en "[${1}] ${GREEN}${2}${NC}\n"
}

Error() {
  echo -en "[${1}] ${RED}${2}${NC}\n"
}

# Yes / No confirmation
confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case "$response" in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            false
            ;;
    esac
}


space() {
  echo -e ""
}

check_bkp_folder() {
    if [[ ! -d "$BACKUPS" ]]; then
        mkdir -p $BACKUPS
    fi
}

users_list(){

    space
    Info "Info" "List of /bin/bash users: "
    users=$(awk -F: '$7=="/bin/bash" { print $1}' /etc/passwd)
    for user in $users
    do
        echo "User: $user, $(id $user | cut -d " " -f 1)"
    done
    space
}

delete_user(){
space
    while :
    do
        read -p "Enter user name: " username
        if [ -z $username ]
        then
            Error "Error" "Username can't be empty"
        else
            if id $username &> /etc/null
            then

                if confirm "Completely delete user (y/n or press enter for n)";
                then
                    sed -i "/$username:/d" /etc/passwd
                    sed -i "/$username:/d" /etc/shadow
                    sed -i "/$username:/d" /etc/group
                    cd /home
                    rm -r $username
                    Info "Info" "User $username deleted"
                    space
                fi
                return 0
            else
                Error "Error" "User $username does not found!"
                space
                return 1
            fi
        fi
    done
}

backup_user(){

space
    while :
    do
        read -p "Enter user name: " username
        if [ -z $username ]
        then
            Error "Error" "Username can't be empty"
        else
            if id $username &> /etc/null
            then
                check_bkp_folder
                homedir=$(grep ${username}: /etc/passwd | cut -d ":" -f 6)
                Info "Info" "Home directory for $username is $homedir "
                Info "Info" "Creating..."
                ts=$(date +%F)
                tar -zcvf $BACKUPS/${username}-${ts}.tar.gz -P $homedir
                Info "Info" "Backup for $username created with name ${username}-${ts}.tar.gz"
                space
                return 0
            else
                Error "Error" "User $user does not found!"
                space
                return 1
            fi
        fi
    done
}

add_user(){

    space
    read -p "Enter user name: " username

    if id -u "$username" >/dev/null 2>&1; then
        Error "Error" "User $user exists. Try to set another user name."
    else
        Info "Info" "User $username will be create.."

    pass=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 18 ; echo)
    user_ID=$(cat /etc/passwd |awk -F ":" '{print $3}' |sort -n |tail -n 2|head -n1)
    user_ID=$(( $user_ID + 1 ))
    group_ID=$(cat /etc/group |awk -F ":" '{print $3}' |sort -n |tail -n 2|head -n1)
    group_ID=$(( $group_ID + 1 ))

    if [ $(cat /etc/passwd |grep $username|wc -l) -eq 0 ]
        then
                #Add user info into /etc/passwd
                echo $user_ID
                echo "------ Add user - $username to /etc/passwd ------"
                echo "Processing ......"
                echo "$username:x:$user_ID:$group_ID:$username,,,:/home/$username:/bin/bash" >> /etc/passwd
                echo "Done"
    else
        echo "User - $username - exist!!!"
    fi

    #Add user info into /etc/group
    if [ $(cat /etc/group |grep "$username" |wc -l) -eq 0 ]
        then
                echo "------ Addgroup - $username to /etc/group ------"
                echo "Processing ......"
                echo "$username:x:$group_ID:" >> /etc/group
                echo "Done"
    else
        echo "Group $username - exist!!!"
    fi

      #Create passord for user
    yes $pass | passwd $username

    #Create dir and change permissions
    if [ ! -d /home/$username ]
        then
                echo "------ Create home dir ------"
                mkdir -v /home/$username
                chown $username:$username /home/$username
    else
        echo "Directory /home/$username - exist!!!"
        chown $username:$username /home/$username
    fi
    Info "Info" "User created. Name: $username. Password: $pass."
fi
space
}

#User menu
 while true
  do
   Menu='Enter yuor choice: '
   options=(
   "Create new user"
   "Backup user"
   "Delete user"
   "Show all users"
   "Quit"
   )
   select opt in "${options[@]}"
   do
     case $opt in
        "Create new user")
           add_user
           break
           ;;
        "Backup user")
           backup_user
           break
           ;;
        "Delete user")
           delete_user
           break
           ;;
        "Show all users")
           users_list
           break
           ;;
        "Quit")
           exit
           ;;
        *) echo invalid option;;
      esac
   done
 done
