#!/bin/bash -e

if [ "$1" != "serve" ]; then
  exec "$@"
fi

PASSWORD_FILE=/home/rclone/htpasswd

if [ -z "${AUTH_USERNAME}" ]; then
  echo "Missing AUTH_USERNAME"
  exit -1
fi

if [ -z "${AUTH_PASSWORD}" ]; then
  echo "Missing AUTH_PASSWORD"
  exit -1
fi

if [ -z "$NAME" ]; then
  echo "Missing NAMEE"
  exit -1
fi

if [ -z "${DOMAIN}" ]; then
  DOMAIN="localhost"
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

htpasswd -b -c ${PASSWORD_FILE} ${AUTH_USERNAME} ${AUTH_PASSWORD}

if [ ! -f "/certs/ca.crt" ] && [ ! -f "/certs/ca.key" ]; then
  openssl req -nodes -x509 -newkey rsa:4096 -keyout /certs/ca.key -out /certs/ca.crt -subj "/C=DE/ST=SA/L=MD/O=rclone/OU=root/CN=ca/emailAddress=rclone@example.com"
fi

if [ ! -f "/certs/server-$NAME.key" ] && [ ! -f "/certs/server-$NAME.crt" ] && [ ! -f "/certs/server-$NAME.pem" ]; then
  if [ ! -f "/certs/ca.srl" ]; then
    SRL="-CAcreateserial -CAserial /certs/ca.srl"
  else
    SRL="-CAserial /certs/ca.srl"
  fi
  openssl req -nodes -newkey rsa:4096 -keyout /certs/server-$NAME.key -out /certs/server-$NAME.csr -subj "/C=DE/ST=SA/L=MD/O=rclone/OU=server/CN=${DOMAIN}/emailAddress=rclone@example.com"
  openssl x509 -req -in /certs/server-$NAME.csr -CA /certs/ca.crt -CAkey /certs/ca.key $SRL -out /certs/server-$NAME.crt
  cat /certs/server-$NAME.crt /certs/ca.crt > /certs/server-$NAME.pem
fi

if [ ! -f "/certs/client-$NAME.key" ] && [ ! -f "/certs/client-$NAME.crt" ] && [ ! -f "/certs/client-$NAME.pem" ]; then
  if [ ! -f "/certs/ca.srl" ]; then
    SRL="-CAcreateserial -CAserial /certs/ca.srl"
  else
    SRL="-CAserial /certs/ca.srl"
  fi
  openssl req -nodes -newkey rsa:4096 -keyout /certs/client-$NAME.key -out /certs/client-$NAME.csr -subj "/C=DE/ST=NSW/L=MD/O=rclone/OU=client/CN=client-$NAME/emailAddress=rclone@example.com"
  openssl x509 -req -in /certs/client-$NAME.csr -CA /certs/ca.crt -CAkey /certs/ca.key $SRL -out /certs/client-$NAME.crt
  cat /certs/client-$NAME.key /certs/client-$NAME.crt > /certs/client-$NAME.pem
fi

echo rclone serve restic $FAST_LIST_PARAM $APPEND_ONLY_PARAM "$SERVE_PARAMS"
rclone serve restic --addr 0.0.0.0:8080 --htpasswd ${PASSWORD_FILE} --cert /certs/server-$NAME.pem --key /certs/server-$NAME.key --client-ca /certs/ca.crt $FAST_LIST_PARAM $APPEND_ONLY_PARAM "$SERVE_PARAMS"