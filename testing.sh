#!/bin/bash

#
# Description: Print list of files for weekly comparison
# Author: tdiprima
#

a=$(pwd)

if (( $# != 1 ))
then
  echo "no arg"

else
  echo "got arg"
  b="$1"
fi

"$a/prt_list.sh" "$b"

