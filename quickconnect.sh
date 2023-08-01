#!/usr/bin/env bash

# QuickConnect

# Author : Bobby Valenzuela
# Created : 6th July 2023

# Description:
# List all of the available hosts in your SSH config file and select one to connect to from numbered list.

getopts "r" opt_rdp
getopts "q" opt_quiet

if [[ "${opt_rdp}" == 'r' ]];then
        echo
        PS3="Which RDP system would you like to RDP into?: "
        COLUMNS=1
        select machine in $(grep -E '^\s*Host\s+RDP' ~/.ssh/config | sed -E 's/Host//' | sort | xargs)
        do
                echo -e "\nSelected ${machine}. Opening..."
                hostname=
                user=
                pass=
                port=

                IFS=$'\n'
                for line in $(grep -EA 3 ${machine} ~/.ssh/config | sed -E 's/\\/\\\\/g')
                do
                        if [[ ${line} =~ HostName ]];then
                                hostname=$(echo ${line} | sed -E 's/HostName//' | xargs)
                        elif [[ ${line} =~ User ]];then
                                user=$(echo "${line}" | sed -E 's/User|:::.*//g' | xargs)
                                pass=$(echo "${line}" | sed -E 's/.*::://' | xargs)
                        elif [[ ${line} =~ Port ]];then
                                port=$(echo "${line}" | sed -E 's/Port//' | xargs)
                        fi
                done
                unset IFS

                # CONNECT XFREERDP
                if [[ $opt_quiet == 'q' ]];then
                        xfreerdp /u:${user} /p:${pass} /v:${hostname}:${port}  +window-drag +dynamic-resolution /w:1920 /h:1080 /cert:ignore &> /dev/null &
                else
                        xfreerdp /u:${user} /p:${pass} /v:${hostname}:${port}  +window-drag +dynamic-resolution /w:1920 /h:1080 /cert:ignore
                fi

                # IF THAT FAILS - TRY RDESKTOP
                if [[ $? -gt 0 ]];then
                        printf "retrying...\n"
                        rdesktop -u ${user} -p ${pass} ${hostname}:${port} -r clipboard:"PRIMARYCLIPBOARD"
                fi

                break
        done

else
        echo
        PS3="Which system would you like to SSH into?: "
        COLUMNS=1
        select machine in $(awk '/^\s*Host\s/ { print $2 }' ~/.ssh/config | sort | grep -v RDP )
        do
                echo -e "\nSelected ${machine}. Connecting...\n"
        
                # If uses pass and hass sshpass..
                pass=$(grep -EA 4 ${machine} ~/.ssh/config | grep -i Pass | sed -E 's/^.*Pass\s?//gi' | xargs)
                echo "PASS: ->${pass}<-"
                if [[ sshpas ]] && [[ ! -z "${pass}" ]];then
                    # key=$(grep -EA 4 ${machine} ~/.ssh/config | grep -i IdentityFile | sed -E 's/^.*Identityfile\s?//gi' | xargs)
                    user=$(grep -EA 4 ${machine} ~/.ssh/config | grep -i User | sed -E 's/^.*User\s?//gi' | xargs)
                    host=$(grep -EA 4 ${machine} ~/.ssh/config | grep -i HostName | sed -E 's/^.*HostName\s?//gi' | xargs)
                    port=$(grep -EA 4 ${machine} ~/.ssh/config | grep -i Port | sed -E 's/^.*Port\s?//gi' | xargs)
                    port_option="-p ${port}"
                    echo "user: ->${user}<-"
                    echo "host: ->${host}<-"
                    echo "port: ->${port}<-"
                    sshpass -p${pass} ssh ${port_option} ${user}@${host}
                fi
                
                ssh $machine
                break
        done
fi

