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
---
apiVersion: v1
kind: Secret
metadata:
  namespace: nexclipper
  name: nex-secrets
  labels:
    app.kubernetes.io/name: nexclipper-kubernetes-agent
stringData:
  username: ${USERNAME}
  nexclipper-api-token: ${APITOKEN}
---
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: nexclipper
  name: nexclipper-agent-config
    labels:
        app.kubernetes.io/name: nexclipper-kubernetes-agent
data:
    instance-name: ${INSTANCENAME}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: nexclipper
  name: nexclipper-role
rules:
- apiGroups: [""]
  resources: ["pods"] # Object 지정
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"] # Action 제어 
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  namespace: nexclipper
  name: nexclipper-rb
subjects:
- kind: ServiceAccount
  name: ${USERNAME}
  namespace: nexclipper
roleRef:
  kind: Role 
  name: nexclipper-role
  apiGroup: rbac.authorization.k8s.io
---
EOF
