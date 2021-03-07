#!/usr/bin/env bash

. ${0%/*}/colors.sh

# list tables from ORIGIN
if ! command -v pg_dump &> /dev/null
then
    perrors "pg_dump could not be found"
    exit 2
fi

TODAY=$(date +%F)
BACKUP_DIR="${0%/*}/../backups"
if [ ! -d "$BACKUP_DIR" ]; then
  mkdir -p $BACKUP_DIR
fi

DUMP_ORIGIN="${BACKUP_DIR}/DUMP_${ORIGIN_DATABASE}_${TODAY}.sql"
DUMP_DESTINY= "${BACKUP_DIR}/DUMP_${DESTINY_DATABASE}_${TODAY}.sql"


pg_dump -h $ORIGIN_HOSTNAME -p $ORIGIN_PORT -U $ORIGIN_USERNAME -F c -b -v -f $DUMP_ORIGIN $ORIGIN_DATABASE

pg_dump -h $DESTINY_HOSTNAME -p $DESTINY_PORT -U $DESTINY_USERNAME -F c -b -v -f $DUMP_DESTINY $DESTINY_DATABASE

diff $DUMP_ORIGIN $DUMP_DESTINY | tee diff_${TODAY}.log
