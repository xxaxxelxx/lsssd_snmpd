#!/bin/bash
test $# -lt 5 && exit 1
MOUNTPOINT="$1"
MYSQL_HOST="$2"
MYSQL_PORT="$3"
MYSQL_DETECTOR_PASSWORD="$4"
ALIVE_LIMIT="$5"

MYSQLCONTROL="mysql -u detector -p$MYSQL_DETECTOR_PASSWORD -D silenceDB -P $MYSQL_PORT -h $MYSQL_HOST --skip-column-names"

# NO DB ENTRY
echo "select mntpnt from status where mntpnt = '$MOUNTPOINT';" | $MYSQLCONTROL | grep "$MOUNTPOINT" > /dev/null
if [ $? -ne 0 ]; then
    echo "1|Not found in database."
    exit 0
fi

# DB ENTRY TOO OLD
echo "select mntpnt from status where mntpnt = '$MOUNTPOINT' and alive < ( UNIX_TIMESTAMP() - $ALIVE_LIMIT );" | $MYSQLCONTROL | grep "$MOUNTPOINT" > /dev/null
if [ $? -eq 0 ]; then
    echo "1|Found in database but too old."
    exit 0
fi


# SILENT
RES="$(echo "select status,since from status where mntpnt = '$MOUNTPOINT' and alive >= ( UNIX_TIMESTAMP() - $ALIVE_LIMIT );" | $MYSQLCONTROL)" #"
STAT="$(echo "$RES" | awk '{print $1}')"
SINCE="$(echo "$RES" | awk '{print $2}' | sed 's|^|@|' | date +"%Y-%m-%d %H:%M:%S")"

echo $SINCE


exit