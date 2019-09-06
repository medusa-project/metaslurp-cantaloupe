#!/bin/sh
#
# Runs the web app locally.

if [ $# -lt 1 ]
then
    echo "Usage: docker-run.sh <env>"
    exit 1
fi

source env.sh env-common.list
source env.sh env-$1.list

docker run -p $CONTAINER_PORT:$CONTAINER_PORT -it \
    --env-file "env-common.list" \
    --env-file "env-$1.list" \
    $IMAGE_NAME
