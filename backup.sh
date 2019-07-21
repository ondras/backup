#!/bin/sh

F=$(readlink "$0")
BASE=$(dirname "$F")

LOGFILE=/tmp/backup.log
FULL_AGE="1M"
MAX_FULL="3"
BUCKET=""
EXTRA=""
HOST="s3.eu-central-1.wasabisys.com"

. $BASE/backup.secrets  # credentials, ...
. $BASE/backup.pre   # dump db, ...

export PASSPHRASE
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY

duplicity --log-file "$LOGFILE" --full-if-older-than $FULL_AGE --include-filelist $BASE/backup.list --exclude '**' / s3://$HOST/$BUCKET $EXTRA > /dev/null
duplicity --log-file "$LOGFILE" remove-all-but-n-full $MAX_FULL --force s3://$HOST/$BUCKET $EXTRA > /dev/null

. $BASE/backup.post  # email logfile, ...

rm "$LOGFILE"
