#!/bin/sh
#
# Builds a Docker image and pushes it to AWS ECR.
#

if [ $# -lt 1 ]
then
    echo "Usage: ecr-push.sh <env>"
    exit 1
fi

source ./env.sh env-common.list
source ./env.sh env-$1.list

./docker-build.sh $1

eval $(aws ecr get-login --no-include-email --region $AWS_REGION --profile $AWS_PROFILE)

# add version tag
TAG=$IMAGE_NAME:$CANTALOUPE_VERSION
docker tag $TAG $ECR_HOST/$TAG
docker push $ECR_HOST/$TAG

# add latest tag
TAG=$IMAGE_NAME:latest
docker tag $TAG $ECR_HOST/$TAG
docker push $ECR_HOST/$TAG
