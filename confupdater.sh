#!/bin/bash
test  $# -lt 5 && \
    echo "usage:   $(basename $0) DB_HOST DB_PORT DB_PASS ALIVE_LIMIT TZ" && \
    echo "example: $(basename $0) 192.168.99.99 3306 mymysqlpass 10 Europe/Berlin" && \
    exit 1

DB_HOST=$1
test "x$DB_HOST" == "x" && exit 1

DB_PORT=$2
test "x$DB_PORT" == "x" && exit 1

DB_PASS=$3
test "x$DB_PASS" == "x" && exit 1

ALIVE_LIMIT=$4
test "x$ALIVE_LIMIT" == "x" && exit 1

TZ=$5
test "x$TZ" == "x" && exit 1

MYSQLCONTROL="mysql -u detector -p$DB_PASS -D silenceDB -P $DB_PORT -h $DB_HOST --skip-column-names"

while true; do
    # STARTUP
    C_MNTPNTLIST="$(echo "SELECT mntpnt FROM status WHERE (UNIX_TIMESTAMP() - $ALIVE_LIMIT > alive);" | mysql -u detector -p$DB_PASS -h $DB_HOST -P $DB_PORT -D silenceDB --skip-column-names)" #"

    for C_MNTPNT in $C_MNTPNTLIST; do

	# TEST FOR NETWORK LOAD
	NETLOAD=$(./get_nload.sh /host/sys $CIF $CIF_SPEED rx)
	test "x$NETLOAD" == "x" && sleep 1 && break
	test $NETLOAD -gt $MAXNETLOAD && sleep 1 && break

	# TEST FOR CPU LOAD
	CPULOAD=$(./get_cpuload.sh /host/proc)
	test "x$CPULOAD" == "x" && sleep 1 && break
	test $CPULOAD -gt $MAXCPULOAD && sleep 1 && break

	sudo -u liquidsoap liquidsoap /etc/liquidsoap/sd.liq -d -- $C_MNTPNT $DB_HOST $DB_PORT $DB_PASS $ALIVE_LIMIT
	sleep 1
    done 
    sleep 1
done

exit $?

# AXXEL.NET
# 2019AUG06
# END
