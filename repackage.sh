#!/bin/sh

CWD=$(pwd)
cd ../../cantaloupe-project/cantaloupe
mvn clean package -DskipTests
cd $CWD
rm ./image_files/cantaloupe-*.zip
cp ../../cantaloupe-project/cantaloupe/target/cantaloupe-*.zip ./image_files
