#!/bin/bash

# Script files
LOCKFILE=/tmp/bashscript.pid
LOGFILE=/tmp/bashscript.log

# Determine dates
DATE="`date +"%d/%b/%Y:%H"`"
DATE_LOG="`date +"%d/%b/%Y %H:%M:%S"`"
DATE_HOUR_AGO="`date --date="1 hour ago" +"%d/%b/%Y:%H"`"
DATE_ERROR="`date --date="1 hour ago" +"%Y/%m/%d %H"`"

# Target log files
ACCESS_LOG=/vagrant/access.log

# Sendmail
MAIL_ADDR=$1
X=$2
Y=$3

# Send report
report()
{
(
cat - <<END
Subject: Otus report
From: test@localhost
To: $MAIL_ADDR

Web server report:

Logs scanned from $DATE_HOUR_AGO to $DATE.

Requests from IP addresses:

${ADDR[@]}

Requested URLs:

${URLS[@]}

Errors:

${ERRO[@]}

Response codes:

${RESPONSE[@]}

END
) | /usr/sbin/sendmail $MAIL_ADDR
}

# Parse logs and send report
if [ -e $LOCKFILE ]
then
        echo "$DATE_LOG --> Script is running!" >> $LOGFILE 2>&1
        exit 1
else
        echo "$$" > $LOCKFILE
        trap 'rm -f $LOCKFILE; exit $?' INT TERM EXIT
        ADDR+=$(grep "$DATE_HOUR_AGO" $ACCESS_LOG | awk '{print $1}' | sort | uniq -c | sort -nr | head -n $2)
        URLS+=$(grep "$DATE_HOUR_AGO" $ACCESS_LOG | awk '{print $7}' | sort | uniq -c | sort -nr | head -n $3)
        ERRO+=$(grep "$DATE_HOUR_AGO" $ACCESS_LOG | grep -v 200)
        RESPONSE+=$(grep "$DATE_HOUR_AGO" $ACCESS_LOG | awk '{print $9}' | sort | uniq -c | sort -nr)
        report
        rm -rf $LOCKFILE
        trap - INT TERM EXIT
        echo "$DATE_LOG --> Report sent!" >> $LOGFILE 2>&1
fi
