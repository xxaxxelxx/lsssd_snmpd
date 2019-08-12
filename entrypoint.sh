#!/bin/bash
set -ex
#set -x

echo "$1" | grep -i '^exit' > /dev/null && exit 0

#SNMPD_HOST="$(ip a | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | grep 172.17 | head -n 1)" #"

test -r "snmpd.conf" && (
    #sed -e "s|<SNMPD_HOST>|${SNMPD_HOST}|g" -i snmpd.conf
    sed -e "s|<SNMPD_COMMUNITY>|${SNMPD_COMMUNITY}|g" -i snmpd.conf 
    )

while true; do
    ./confupdater.sh $MYSQL_HOST $MYSQL_PORT $MYSQL_DETECTOR_PASSWORD $ALIVE_LIMIT $TZ
    sleep 10
done
exit $?
