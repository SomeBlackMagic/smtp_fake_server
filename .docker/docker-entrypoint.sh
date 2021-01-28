#!/bin/bash

set -e
set -o pipefail

echo "[Entrypoint] SMTP fake server"
###
### Globals
###
# Path to scripts to source
CONFIG_DIR="/docker-entrypoint.d"

CONFIG_FILE=/opt/application.properties
SERVER_PORT="${SERVER_PORT:-5080}"
MANAGEMENT_SERVER_PORT="${MANAGEMENT_SERVER_PORT:-5081}"
FAKESMTP_PORT="${FAKESMTP_PORT:-5025}"

#FAKESMTP_BIND_ADDRESS=
#FAKESMTP_PERSISTENCE_MAX_NUMBER_EMAILS=
#FAKESMTP_AUTHENTICATION_USERNAME=
#FAKESMTP_AUTHENTICATION_PASSWORD=
#FAKESMTP_FILTERED_EMAIL_REGEX_LIST=
#FAKESMTP_FORWARD_EMAILS=


###
### Source libs
###
init="$( find "${CONFIG_DIR}" -name '*.sh' -type f | sort -u )"
for f in ${init}; do
    case "$f" in
      *.sh)  echo "[Entrypoint] running $f"; . "$f" ;;
      *)     echo "[Entrypoint] ignoring $f" ;;
    esac
    echo
done

echo '[Entrypoint] Create config file'

touch $CONFIG_FILE;
cat > $CONFIG_FILE <<EOF
server.port=${SERVER_PORT}
#management.server.port=${MANAGEMENT_SERVER_PORT}
#fakesmtp.port=${FAKESMTP_PORT}
EOF

if [ ! -z "$FAKESMTP_BIND_ADDRESS" ]; then
  printf "fakesmtp.bindAddress=${FAKESMTP_BIND_ADDRESS} \n" >> $CONFIG_FILE
fi

if [ ! -z "$FAKESMTP_PERSISTENCE_MAX_NUMBER_EMAILS" ]; then
  printf "fakesmtp.persistence.maxNumberEmails=${FAKESMTP_PERSISTENCE_MAX_NUMBER_EMAILS} \n" >> $CONFIG_FILE
fi

if [ ! -z "$FAKESMTP_AUTHENTICATION_USERNAME" ]; then
  printf "fakesmtp.authentication.username=${FAKESMTP_AUTHENTICATION_USERNAME} \n" >> $CONFIG_FILE
fi

if [ ! -z "$FAKESMTP_AUTHENTICATION_PASSWORD" ]; then
  printf "fakesmtp.authentication.password=${FAKESMTP_AUTHENTICATION_PASSWORD} \n" >> $CONFIG_FILE
fi

if [ ! -z "$FAKESMTP_FILTERED_EMAIL_REGEX_LIST" ]; then
  printf "fakesmtp.filteredEmailRegexList=${FAKESMTP_FILTERED_EMAIL_REGEX_LIST} \n" >> $CONFIG_FILE
fi

if [ ! -z "$FAKESMTP_FORWARD_EMAILS" ]; then
  printf "fakesmtp.forwardEmails=${FAKESMTP_FORWARD_EMAILS} \n" >> $CONFIG_FILE
fi

printf "java ${JAVA_OPTS} -Djava.security.egd=file:/dev/./urandom -Dspring.config.location=/opt/application.properties -jar /opt/fake-smtp-server.jar" > /run.sh

echo "[Entrypoint] init process done. Ready for start up."

exec "${@}"
