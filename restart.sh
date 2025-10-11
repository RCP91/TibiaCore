#!/bin/bash

# script to run the automatic server again in case of crash
echo "Starting the program"

cd /opt/TibiaCore || exit 1
mkdir -p logs

# config mysql
usersql="root"
servername="tibiacore"
sqlpassword="${MYSQL_ROOT_PASSWORD}"

date=`date "+%d-%m-%y-%H-%M-%S"`
filename="${servername}-${date}"
databasefile="${filename}.sql"

#necessary configurations for Anti-rollback
ulimit -c unlimited
set -o pipefail

while true
do
    # the antirollback_config file must be in the working folder
    gdb --batch -return-child-result --command=antirollback_config --args ./TibiaCore 2>&1 | awk '{ print strftime("%F %T - "), $0; fflush(); }' | tee "logs/$(date +"%F %H-%M-%S").log"
    mysqldump -u"$usersql" -p"$sqlpassword" --add-drop-table --add-locks --allow-keywords --extended-insert --quick --compress "$servername" > "/opt/TibiaCore/$databasefile"
    gzip -f "/opt/TibiaCore/$databasefile"
   
    if [ $? -eq 0 ]; then
        echo "Exit code 0, waiting 3 minutes..."
    sleep 180    # 3 minutes
    else
        echo "Crash !! Restarting the server in 5 seconds (The log file is saved in the logs folder)"
        echo "If you want to shut down the server, press CTRL + C ..."
        sleep 5
    fi
done;
