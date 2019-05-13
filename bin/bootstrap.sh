#!/bin/bash

# line
echo '******************************************************************************'
echo '* Starting Reactive Drop server                                              *'
echo '******************************************************************************'

# vars
SLEEP_TIME=10

# run updates
/usr/games/steamcmd \
    +@sSteamCmdForcePlatformType windows \
    +login anonymous \
    +app_update 563560 \
    +quit

# get the ip address
ip=$(wget -q -O- "https://api.ipify.org/")
#ip="127.0.0.1"

# gui/console
export DISPLAY=:0
export WINEARCH="win32"
export WINEDEBUG="-all"
export WINEDLLOVERRIDES="mscoree=d;mshtml=d"
#export WINEDEBUG="+synchronous,+loaddll,+seh,+msgbox,+fixme"

function write_server_config()
{
    file=$1

    # load the server.cfg file
    echo "exec server.cfg" > $file

    # look for other settings for this server
    for vars in $(set | grep "^rd\_server\_${nr}\_"); do
        var=$(echo "${vars}" | cut -d '_' -f 4- | cut -d '=' -f 1)
        value=$(echo "${vars}" | cut -d '=' -f 2- | sed "s/\\\\'/\#/g" | sed "s/'//g" | sed "s/#/'/g")

        # write the var the the server config file
        echo "${var} = ${value}" >> $file
    done
}

function write_sourcemod_admins_simple()
{
    if [[ "$sourcemod_admin_steamid" != "" ]]; then
        echo "\"$sourcemod_admin_steamid\" \"z\"" > reactivedrop/addons/sourcemod/configs/admins_simple.ini
    fi

}

function write_sourcemod_sourcebans_config()
{
    file="addons/sourcemod/configs/databases.cfg"

    if [[ "${sourcebans_host}" != "" ]]; then
        sed -i'' "s/#sourcebans_host#/${sourcebans_host}/g" $file
        sed -i'' "s/#sourcebans_port#/${sourcebans_port}/g" $file
        sed -i'' "s/#sourcebans_user#/${sourcebans_user}/g" $file
        sed -i'' "s/#sourcebans_password#/${sourcebans_password}/g" $file
        sed -i'' "s/#sourcebans_database#/${sourcebans_database}/g" $file
    fi
}

# run a persistent wine server during initialization
/usr/bin/wineserver -k -p 60

# switch to reactive drop folder
cd /root/reactivedrop/

# set ifs
IFS=$'\n'

# get defined servers
servers=$(set | grep "^rd\_server\_[0-9]\{1,\}\_port=[0-9]\{4,5\}$")

# loop
while [[ true ]]; do

    # iterate
    for server in $servers; do

        # get server number
        nr=$(echo "${server}" | cut -d '_' -f 3)
        port=$(echo "${server}" | cut -d '=' -f 2-)

        # check if the server is running already
        running=$(pgrep -f "${port}")

        if [[ "$running" = "" ]]; then

            # write a configuration file for this server
            config="server_${nr}.cfg"
            console="console_${nr}.log"
            file="reactivedrop/cfg/${config}"

            # write some configs
            write_server_config "${file}"
            write_sourcemod_admins_simple
            write_sourcemod_sourcebans_config

            # create a copy of the sourcemod folder
            smbase="reactivedrop/addons/sourcemod_${i}"
            cp -a reactivedrop/addons/sourcemod $smbase

            # check if the env does exist
            wine start \
                ./srcds.exe \
                -console \
                -game reactivedrop \
                -port $port \
                -threads 1 \
                -nomessagebox \
            	-nocrashdialog \
                -num_edicts 4096 \
                +con_logfile $console \
                +exec $config \
                +sm_basepath $smbase

            # wait a bit before attempting to start the next server
            sleep $SLEEP_TIME
         fi
    done

    sleep $SLEEP_TIME
done