#!/bin/bash -e

if [ "$1" != "serve" ]; then
  exec "$@"
fi

if [ -z "${AUTH_USERNAME}" ]; then
  echo "Missing AUTH_USERNAME"
  exit -1
fi

if [ -z "${AUTH_PASSWORD}" ]; then
  echo "Missing AUTH_PASSWORD"
  exit -1
fi

if [ -z "$NAME" ]; then
  echo "Missing NAME"
  exit -1
fi

if [ -z "${AUTH_TITLE}" ]; then
  export AUTH_TITLE="Protected rclone service"
fi

if [ ! -z "$APPEND_ONLY" ]; then
  APPEND_ONLY_PARAM="--append-only"
fi

if [ ! -z "$FAST_LIST" ]; then
  FAST_LIST_PARAM="--fast-list"
fi

PASSWORD_FILE=/home/rclone/htpasswd
rm -rf ${PASSWORD_FILE}
htpasswd -b -c ${PASSWORD_FILE} ${AUTH_USERNAME} ${AUTH_PASSWORD}

echo rclone serve restic $FAST_LIST_PARAM $APPEND_ONLY_PARAM "$SERVE_PARAMS"
rclone serve restic --addr 0.0.0.0:8080 --htpasswd ${PASSWORD_FILE} --cert /certs/server-$NAME.pem --key /certs/server-$NAME.key --client-ca /certs/ca-$NAME.crt $FAST_LIST_PARAM $APPEND_ONLY_PARAM "$SERVE_PARAMS"
