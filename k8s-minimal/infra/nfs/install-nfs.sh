#!/usr/bin/env bash

NFS_SERVER="192.168.178.47"
NFS_PATH="/data"

helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
  --set "nfs.server=${NFS_SERVER}" \
  --set "nfs.path=${NFS_PATH}"
