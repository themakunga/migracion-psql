#!/usr/bin/env bash

. ${0%/*}/colors.sh

echo '
    ____        __        __
   / __ \____ _/ /_____ _/ /_  ____ _________
  / / / / __ `/ __/ __ `/ __ \/ __ `/ ___/ _ \
 / /_/ / /_/ / /_/ /_/ / /_/ / /_/ (__  )  __/
/_____/\__,_/\__/\__,_/_.___/\__,_/____/\___/

    ____             __   __  __
   / __ )____ ______/ /__/ / / /___
  / __  / __ `/ ___/ //_/ / / / __ \
 / /_/ / /_/ / /__/ ,< / /_/ / /_/ /
/_____/\__,_/\___/_/|_|\____/ .___/ '



# verify if dump postgres is installed
if ! command -v pg_dump &> /dev/null
then
    perrors "pg_dump could not be found"
    exit 2
fi

# verify if env file exist
ENV="${0%/*}/../.env"
if [ ! -f "$ENV" ]; then
  perrors "there is no valid .env file"
fi
verify vars
while IFS= read -r line
do
  echo $line
  if [[ "$line" == *= ]]; then
    perrors "variable ${line} is empty"
  fi
done < <(cat $ENV)


# call the env file
export $(egrep -v '^#' $ENV | xargs)

TODAY=$(date +%F)
BACKUP_DIR="${0%/*}/../backups"
if [ ! -d "$BACKUP_DIR" ]; then
  mkdir -p $BACKUP_DIR
fi
BACKUP_FILE="${BACKUP_DIR}/${ORIGIN_DATABASE}_${TODAY}.sql"

# backup db
export PGPASSWORD=$ORIGIN_PASSWORD
cecho "start backup"
pg_dump -h $ORIGIN_HOSTNAME -p $ORIGIN_PORT -U $ORIGIN_USERNAME -F c -b -v -f $BACKUP_FILE $ORIGIN_DATABASE
cecho "backup ended"
