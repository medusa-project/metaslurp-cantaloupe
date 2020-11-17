#!/bin/bash
#
# Copies Docker environment variables from one of the Docker variable files
# into shell environment variables.
#

if [ $# -lt 1 ]
then
    echo "Usage: env.sh <filename>"
    exit 1
fi

while read p; do
  if [[ $p != "#"* && $p != "" ]]; then
    IFS='=' read -ra parts <<< "$p"
    export "${parts[0]}"="${parts[1]}"
  fi
done < $1

ZIP_FILE=$(ls image_files/cantaloupe-*)
CANTALOUPE_VERSION=$(echo $ZIP_FILE | sed -En 's/image_files\/cantaloupe-(.+).zip$/\1/p')