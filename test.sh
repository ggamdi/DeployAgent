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
        --user-name=*)
        USERNAME="${i#*=}"
        shift
        ;;
esac
done

echo "INSTANCENAME      = ${INSTANCENAME}"
echo "APITOKEN          = ${APITOKEN}"
echo "USERNAME          = ${USERNAME}"

kubectl create ns nexclipper

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: ${USERNAME}
  namespace: nexclipper
EOF
