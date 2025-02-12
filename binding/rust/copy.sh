#! /bin/bash

echo "Removing old data ..."
rm -rf ./data


echo "Preparing dir ..."
mkdir -p ./data/lib/
mkdir -p ./data/resources/

echo "Copying Model File ..."
cp -r ../../lib/common ./data/lib/


for platform in beaglebone jetson linux mac raspberry-pi windows
do
    echo "Copying Library Files for $platform ..."
    cp -r ../../lib/$platform ./data/lib/
done

echo "Copy complete!"