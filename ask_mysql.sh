#!/bin/bash
test $# -lt 5 && exit 1
MOUNTPOINT="$1"
MYSQL_HOST="$2"
MYSQL_PORT="$3"
MYSQL_DETECTOR_PASSWORD="$4"
ALIVE_LIMIT="$5"

MYSQLCONTROL="mysql -u detector -p$MYSQL_DETECTOR_PASSWORD -D silenceDB -P $MYSQL_PORT -h $MYSQL_HOST --skip-column-names"

echo "select alive from status where mntpnt = '$MOUNTPOINT' and alive < ( UNIX_TIMESTAMP() - $ALIVE_LIMIT );" | $MYSQLCONTROL




exit