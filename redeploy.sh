#!/bin/sh

if [ $# -lt 1 ]
then
    echo "Usage: redeploy.sh <env>"
    exit 1
fi

./docker-build.sh $1
./ecr-push.sh $1
./ecs-deploy.sh $1
