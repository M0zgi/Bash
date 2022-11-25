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

read -p "Enter process name: " process_name
    if [ -z $process_name ]
      then
      Error "Error" "Process name can't be empty"
     else
       pids=$(pidof "$process_name")
       if [ $(pidof "$process_name" | wc -l) -eq 0 ]
         then
           Error "Error" "Process not found"
       else
           for pid in $pids
            do
	           tempId=$(ps -p "$pid")
             echo "PID: $tempId"
            done
      fi
    fi