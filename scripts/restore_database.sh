#!/usr/bin/env bash

. ${0%/*}/colors.sh

# verify if dump postgres is installed
if ! command -v pg_restore &> /dev/null
then
    perrors "pg_restore could not be found"
    exit 2
fi

# verify if dump postgres is installed
if ! command -v psql &> /dev/null
then
    perrors "psql could not be found"
    exit 2
fi

TODAY=$(date +%F)
BACKUP_DIR="${0%/*}/../backups"
if [ ! -d "$BACKUP_DIR" ]; then
  mkdir -p $BACKUP_DIR
fi
BACKUP_FILE="${BACKUP_DIR}/${ORIGIN_DATABASE}_${TODAY}.sql"

unset -v LATEST
for file in "$BACKUP_DIR"/*; do
  [[ $file -nt $LATEST ]] && LATEST=$file
done


if [ $# -eq 1 ]; then
    BACKUP_FILE=$1
  else
    BACKUP_FILE="${BACKUP_DIR}/${ORIGIN_DATABASE}_${TODAY}.sql"
fi

# previous snapshot
BACKUP_FILE_SNAPSHOT="${BACKUP_DIR}/${DESTINY_DATABASE}_${TODAY}.sql"
export PGPASSWORD=$DESTINY_PASSWORD
cecho "backup snapshot"
pg_dump -h $DESTINY_HOSTNAME -p $DESTINY_PORT -U $DESTINY_USERNAME -F c -b -v -f $BACKUP_FILE_SNAPSHOT $DESTINY_DATABASE
cecho "backup ended"


# clean destiny database
psql -h $DESTINY_HOST -p $DESTINY_PORT -U $DESTINY_USER postgres -c "DROP DATABASE $DESTINY_NAME;"
psql -h $DESTINY_HOST -p $DESTINY_PORT -U $DESTINY_USER postgres -c "CREATE DATABASE $DESTINY_NAME;"



# restore database backup
pg_restore -h $DESTINY_HOST -p $DESTINY_PORT -U $DESTINY_USER -d $DESTINY_NAME --no-owner --role=$DESTINY_USER -v $BACKUP_FILE

cecho "Restore process ended"

cecho "if you want to restore previous snapshot run the following command ${$0} ${BACKUP_FILE_SNAPSHOT}"
