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
# verify vars
while IFS= read -r line
do
  echo $line
  if [[ "$line" == *= ]]; then
    perrors "variable ${line} is empty"
  fi
done < <(cat $ENV)


# call the env file
export $(egrep -v '^#' $ENV | xargs)
