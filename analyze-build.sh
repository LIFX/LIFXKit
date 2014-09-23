#!/usr/bin/env bash

echo "----- Running make... -----"

build_errors_file=build_errors.log

# Pipe errors to file
make clean analyze 2>$build_errors_file

errors=`grep -wc "analyzer issues:" $build_errors_file`
if [ "$errors" != "0" ]
then
    cat $build_errors_file
    rm $build_errors_file
    exit 1
fi
echo "No issues found"
rm $build_errors_file
