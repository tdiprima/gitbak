#!/bin/bash

#
# Print list of files for weekly comparison
#
me=$(basename "$0")
cwd=$(pwd)
target="$cwd"
tstamp=$(date +%Y-%m-%d_%H-%M-%S)
filename="$tstamp.list"

if (( $# != 1 ))
then
  echo "Usage: ./$me directoryName"
  # exit 1
else
  target="$cwd/$1"
  filename="$1.list"
fi

touch "$filename"

for file in "$target"/*
do
  echo $(printf "%s\n" "$file" | cut -d"/" -f7) >> $filename
done
