#!/bin/sh

set -e

volume_host_folder="$HOME/tmp/da-pg-dbs/db-$1"
mkdir -p $volume_host_folder

ls Dockerfile && \
    docker build -t da-pg . && \
    docker run -d --rm --name "da-pg-$1" -p 127.0.0.1:5432:5432 -v "$volume_host_folder:/var/lib/postgresql/data" da-pg && \
    ../wait-for-it.sh localhost:5432 && \
    sleep 3 && \
    docker run -it --rm --name "da-pg-$1-client" --network=host da-pg psql -h localhost -U postgres

docker stop "da-pg-$1"
