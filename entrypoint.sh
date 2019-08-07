#!/bin/bash
set -ex
#set -x

echo "$1" | grep -i '^exit' > /dev/null && exit 0

while true; do
	test -r "/etc/snmp/snmpd.conf" && (
	    sed -e "s|<SNMPD_HOST>|${SNMPD_HOST}|g" -i /etc/snmp/snmpd.conf
	    sed -e "s|<SNMPD_COMMUNITY>|${SNMPD_COMMUNITY}|g" -i /etc/snmp/snmpd.conf 
	    )

#    ./detectorrunner.sh $DETECTORHOST_IF $DETECTORHOST_IF_SPEED $DETECTORHOST_IF_MAXLOAD_PERCENT $DETECTORHOST_MAXCPULOAD_PERCENT $MYSQL_HOST $MYSQL_PORT $MYSQL_DETECTOR_PASSWORD $ALIVE_LIMIT
    sleep 60
done
exit $?
