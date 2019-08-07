#!/bin/bash
set -ex
#set -x

echo "$1" | grep -i '^exit' > /dev/null && exit 0

test -r "snmpd.conf" && (
    sed -e "s|<SNMPD_HOST>|${SNMPD_HOST}|g" -i snmpd.conf
    sed -e "s|<SNMPD_COMMUNITY>|${SNMPD_COMMUNITY}|g" -i snmpd.conf 
    )


while true; do
#    ./confupdater.sh 192.168.100.124 63306 rfc1830 10 Europe/Berlin
    ./confupdater.sh $MYSQL_HOST $MYSQL_PORT $MYSQL_DETECTOR_PASSWORD $ALIVE_LIMIT $TZ
#    echo "$MYSQL_HOST $MYSQL_PORT $MYSQL_DETECTOR_PASSWORD $ALIVE_LIMIT $TZ" > aaaa
    sleep 10
done
exit $?
