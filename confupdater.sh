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

WATCHLIST="/volumes/CommandVolume/WATCHLIST"
test "x$WATCHLIST" == "x" && exit 1
test -r "$WATCHLIST" || exit 1

MYSQLCONTROL="mysql -u detector -p$DB_PASS -D silenceDB -P $DB_PORT -h $DB_HOST --skip-column-names"

while true; do
#    C_MD5_PRE="$C_MD5"
#    C_MNTPNTLIST="$(echo "SELECT mntpnt FROM status;" | mysql -u detector -p$DB_PASS -h $DB_HOST -P $DB_PORT -D silenceDB --skip-column-names)" #"
#    C_MD5="$(echo "$C_MNTPNTLIST" | md5sum | awk '{print $1}')"
#    test "x$C_MD5_PRE" == "x$C_MD5" && sleep 600 && continue
    MD5SUMPRE="$MD5SUM"
    MD5SUM="$(cat "$WATCHLIST" | grep -v -e '^#' -e '^\s*$' | awk '{print $1}' | md5sum | awk '{print $1}')"
    test "x$MD5SUMPRE" == "x$MD5SUM" && sleep 10 && continue

    date > DATE

    SNMPD_EXTEND_BLOCK=""
    for C_MNTPNT in $C_MNTPNTLIST; do
	C_MNTPNT_ID="$(echo "$C_MNTPNT" | sed 's|.*\:\/\/||' | sed 's|\.|\_|g' | sed 's|\/|\_|g')" #"
	SNMPD_EXTEND_BLOCK=$"${SNMPD_EXTEND_BLOCK}|extend $C_MNTPNT_ID ask_mysql.sh $C_MNTPNT $DB_HOST $DB_PORT $DB_PASS $ALIVE_LIMIT $TZ"
    done 

    test -r snmpd.conf && cp -f snmpd.conf /etc/snmp/snmpd.conf && \
    echo "$SNMPD_EXTEND_BLOCK" | tr '\|' '\n' > /etc/snmp/extend.conf

    sleep 1
    ps waux | grep snmpd | grep -v grep > /dev/null && pkill -HUP snmpd || snmpd -c /etc/snmp/extend.conf
    sleep 10
done

exit $?

# AXXEL.NET
# 2019AUG06
# END
