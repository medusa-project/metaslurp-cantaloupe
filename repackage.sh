#!/bin/sh

if [ $# -eq 0 ]
  then
    echo "Usage: repackage.sh <cantaloupe version>"
    exit -1
fi

CWD=$(pwd)
cd ../../cantaloupe-project/cantaloupe
mvn clean package -DskipTests
cd $CWD
rm ./image_files/cantaloupe-*.zip
cp ../../cantaloupe-project/cantaloupe/target/cantaloupe-*.zip ./image_files
./docker-build.sh
