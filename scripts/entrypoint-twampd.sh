#!/bin/bash
set -e

DATA_DIR=${DATA_DIR}

create_twamp_dir() {
  # populate default twamp-server configuration if it does not exist
  if [ ! -f ${DATA_DIR}/twamp-server.conf ]; then
    cp /etc/twamp-server/twamp-server.conf ${DATA_DIR}/
  fi

  if [ ! -f ${DATA_DIR}/twamp-server.limits ]; then
    cp /etc/twamp-server/twamp-server.limits ${DATA_DIR}/
  fi
}

create_twamp_dir

echo "Starting supervisord..."
exec $(which supervisord) -c /etc/supervisor.conf
