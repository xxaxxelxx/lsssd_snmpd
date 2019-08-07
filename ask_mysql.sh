#!/bin/bash
test $# -lt 4 && exit 1
MOUNTPOINT="$1"
MYSQL_HOST="$2"
MYSQL_PORT="$3"
MYSQL_DETECTOR_PASSWORD="$4"

MYSQLCONTROL="mysql -u detector -p$MYSQL_DETECTOR_PASSWORD -D silenceDB -P $MYSQL_PORT -h $MYSQL_HOST"

echo "select alive,status,since from status where mntpnt = '$MOUNTPOINT';" | $MYSQLCONTROL

exit