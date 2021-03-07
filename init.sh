#!/usr/bin/env bash
echo "
██████╗░░█████╗░░██████╗████████╗░██████╗░██████╗░███████╗░██████╗
██╔══██╗██╔══██╗██╔════╝╚══██╔══╝██╔════╝░██╔══██╗██╔════╝██╔════╝
██████╔╝██║░░██║╚█████╗░░░░██║░░░██║░░██╗░██████╔╝█████╗░░╚█████╗░
██╔═══╝░██║░░██║░╚═══██╗░░░██║░░░██║░░╚██╗██╔══██╗██╔══╝░░░╚═══██╗
██║░░░░░╚█████╔╝██████╔╝░░░██║░░░╚██████╔╝██║░░██║███████╗██████╔╝
╚═╝░░░░░░╚════╝░╚═════╝░░░░╚═╝░░░░╚═════╝░╚═╝░░╚═╝╚══════╝╚═════╝░

██████╗░░█████╗░████████╗░█████╗░██████╗░░█████╗░░██████╗███████╗
██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔════╝
██║░░██║███████║░░░██║░░░███████║██████╦╝███████║╚█████╗░█████╗░░
██║░░██║██╔══██║░░░██║░░░██╔══██║██╔══██╗██╔══██║░╚═══██╗██╔══╝░░
██████╔╝██║░░██║░░░██║░░░██║░░██║██████╦╝██║░░██║██████╔╝███████╗
╚═════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚═╝╚═════╝░╚═╝░░╚═╝╚═════╝░╚══════╝

███╗░░░███╗██╗░██████╗░██████╗░░█████╗░████████╗██╗░█████╗░███╗░░██╗
████╗░████║██║██╔════╝░██╔══██╗██╔══██╗╚══██╔══╝██║██╔══██╗████╗░██║
██╔████╔██║██║██║░░██╗░██████╔╝███████║░░░██║░░░██║██║░░██║██╔██╗██║
██║╚██╔╝██║██║██║░░╚██╗██╔══██╗██╔══██║░░░██║░░░██║██║░░██║██║╚████║
██║░╚═╝░██║██║╚██████╔╝██║░░██║██║░░██║░░░██║░░░██║╚█████╔╝██║░╚███║
╚═╝░░░░░╚═╝╚═╝░╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚═╝░╚════╝░╚═╝░░╚══╝

░██████╗░█████╗░██████╗░██╗██████╗░████████╗
██╔════╝██╔══██╗██╔══██╗██║██╔══██╗╚══██╔══╝
╚█████╗░██║░░╚═╝██████╔╝██║██████╔╝░░░██║░░░
░╚═══██╗██║░░██╗██╔══██╗██║██╔═══╝░░░░██║░░░
██████╔╝╚█████╔╝██║░░██║██║██║░░░░░░░░██║░░░
╚═════╝░░╚════╝░╚═╝░░╚═╝╚═╝╚═╝░░░░░░░░╚═╝░░░
"

T=$(date +"%F")
LOGFILE="${0%/*}/../logs/${T}.log"
touch "$LOGFILE"

cecho() {
  NC='\e[0m' # No Color
  BLACK='\e[0;30m'
  GRAY='\e[1;30m'
  RED='\e[0;31m'
  LIGHT_RED='\e[1;31m'
  GREEN='\e[0;32m'
  LIGHT_GREEN='\e[1;32m'
  BROWN='\e[0;33m'
  YELLOW='\e[1;33m'
  BLUE='\e[0;34m'
  LIGHT_BLUE='\e[1;34m'
  PURPLE='\e[0;35m'
  LIGHT_PURPLE='\e[1;35mc'
  CYAN='\e[0;36m'
  LIGHT_CYAN='\e[1;36m'
  LIGHT_GRAY='\e[0;37m'
  WHITE='\e[1;37m'
  DATE=$(date +"%F %T")
  printf "[${DATE}] ${!1}${2} ${NC}\n"
  printf "[${DATE}] ${2}\n" >> $LOGFILE
}

perrors() {
  cecho "RED" "ERRROR!: ${1}"
  exit 2
}

pwarn() {
  cecho "YELLOW" "WARNING!: ${1}"
}

pok () {
  cecho "GREEN" "SUCCESS!: ${1}"
}

# verify if env file exist
ENV="${0%/*}/../.env"
if [ ! -f "$ENV" ]; then
  perrors "there is no valid .env file"
fi


if ! hash pg_restore 2>/dev/null
then
    perrors "pg_restore could not be found"
    exit 2
fi

# verify if dump postgres is installed
if ! hash pg_dump 2>/dev/null; then
    perrors "pg_dump could not be found"
    exit 2
fi


# verify if dump postgres is installed
if ! hash pqsl 2>/dev/null; then
    perrors "pqsl could not be found"
    exit 2
fi

# verify vars
# while IFS= read -r line
# do
#   echo $line
#   if [[ "$line" == "*=" ]]; then
#     perrors "variable ${line} is empty"
#   fi
# done < $ENV


# call the env file
export $(egrep -v '^#' $ENV | xargs)

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



TODAY=$(date +%F)
BACKUP_DIR="${0%/*}/../backups"
if [ ! -d "$BACKUP_DIR" ]; then
  mkdir -p $BACKUP_DIR
fi
BACKUP_FILE="${BACKUP_DIR}/${ORIGIN_DATABASE}_${TODAY}.sql"

# backup db
export PGPASSWORD=$ORIGIN_PASSWORD
pok "start backup"
pg_dump -h $ORIGIN_HOSTNAME -p $ORIGIN_PORT -U $ORIGIN_USERNAME -F c -b -v -f $BACKUP_FILE $ORIGIN_DATABASE
pok "backup ended"

# previous snapshot
BACKUP_FILE_SNAPSHOT="${BACKUP_DIR}/${DESTINY_DATABASE}_${TODAY}.sql"
export PGPASSWORD=$DESTINY_PASSWORD
pok "backup snapshot"
pg_dump -h $DESTINY_HOSTNAME -p $DESTINY_PORT -U $DESTINY_USERNAME -F c -b -v -f $BACKUP_FILE_SNAPSHOT $DESTINY_DATABASE
pok "backup ended"

# clean destiny database
psql -h $DESTINY_HOST -p $DESTINY_PORT -U $DESTINY_USER postgres -c "DROP DATABASE $DESTINY_NAME;"
psql -h $DESTINY_HOST -p $DESTINY_PORT -U $DESTINY_USER postgres -c "CREATE DATABASE $DESTINY_NAME;"

# restore database backup
pg_restore -h $DESTINY_HOST -p $DESTINY_PORT -U $DESTINY_USER -d $DESTINY_NAME --no-owner --role=$DESTINY_USER -v $BACKUP_FILE


DUMP_ORIGIN="${BACKUP_DIR}/DUMP_${ORIGIN_DATABASE}_${TODAY}.sql"
DUMP_DESTINY= "${BACKUP_DIR}/DUMP_${DESTINY_DATABASE}_${TODAY}.sql"


pg_dump -h $ORIGIN_HOSTNAME -p $ORIGIN_PORT -U $ORIGIN_USERNAME -F c -b -v -f $DUMP_ORIGIN $ORIGIN_DATABASE

pg_dump -h $DESTINY_HOSTNAME -p $DESTINY_PORT -U $DESTINY_USERNAME -F c -b -v -f $DUMP_DESTINY $DESTINY_DATABASE

diff $DUMP_ORIGIN $DUMP_DESTINY | tee diff_${TODAY}.log
