#!/usr/bin/env bash

kubectl apply -f namespace.yaml
./init-secrets.sh
kubectl apply -f hzn-core.pvc.config.yaml
kubectl apply -f hzn-core.pvc.data.yaml
kubectl apply -f hzn-core.pvc.logs.yaml
kubectl apply -f hzn-core.configmap.yaml
kubectl apply -f hzn-core.configmap-scripts.yaml
kubectl apply -f hzn-core.statefulset.yaml
kubectl apply -f hzn-core.service-tcp.yaml
kubectl apply -f hzn-core.service-udp.yaml

