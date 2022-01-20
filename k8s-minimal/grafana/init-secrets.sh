#!/usr/bin/env bash

kubectl create secret generic grafana-secrets \
  --from-literal="GF_SECURITY_ADMIN_PASSWORD=kzqMpHG4vnX8QU8Z" \
  -n chaos-engine
