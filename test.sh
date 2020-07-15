#!/bin/bash

for i in "$@"
do
case $i in
        --instance-name=*)
        INSTANCENAME="${i#*=}"
        shift
        ;;
        --api-token=*)
        APITOKEN="${i#*=}"
        shift
        ;;
esac
done

echo "INSTANCENAME      = ${INSTANCENAME}"
echo "APITOKEN          = ${APITOKEN}"

kubectl create ns nexclipper

