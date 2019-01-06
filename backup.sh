#!/bin/sh

F=$(readlink "$0")
BASE=$(dirname "$F")

LOGFILE=/tmp/backup.log
FULL_AGE="1M"
MAX_AGE="3M"
BUCKET=""
EXTRA=""

. $BASE/backup.secrets  # credentials, ...
. $BASE/backup.pre   # dump db, ...

export PASSPHRASE
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY

duplicity --log-file "$LOGFILE" --full-if-older-than $FULL_AGE --include-filelist $BASE/backup.list --exclude '**' / s3://s3.wasabisys.com/$BUCKET $EXTRA
duplicity --log-file "$LOGFILE" remove-older-than $MAX_AGE s3://s3.wasabisys.com/$BUCKET $EXTRA

. $BASE/backup.post  # email logfile, ...

rm "$LOGFILE"

