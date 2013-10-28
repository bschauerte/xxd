#!/bin/bash

TEST_FOLDER="test_package"
FILES="README.md xxd.m xxd_demo.m"

# copy the files and try to compile, if it failes, then the package is broken!
rm -rf $TEST_FOLDER
mkdir $TEST_FOLDER
for file in $FILES; do
	cp $file in $TEST_FOLDER
done
cd $TEST_FOLDER
zip -r xxd_matlab.zip *.*
