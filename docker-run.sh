#!/bin/sh

if [ $# -lt 1 ]
then
    echo "Usage: docker-run.sh <env>"
    exit 1
fi

source env.sh env-$1.list

docker-compose --env-file env-$1.list up --build
