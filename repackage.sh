#!/bin/sh

VERSION=$1

if [ $# -eq 0 ]
  then
    echo "Usage: repackage.sh <cantaloupe version>"
    exit -1
fi

CWD=$(pwd)
cd ../cantaloupe
mvn clean package -DskipTests
cd $CWD
cp ../cantaloupe/target/cantaloupe-$VERSION.zip ./image_files
./docker-build.sh
