#!/usr/bin/env bash

kubectl create secret generic hzn-core-secrets \
  --from-literal="POSTGRES_PASSWORD=xQadUEDMc4ejp7p7" \
  --from-literal="OPENNMS_DBPASS=cglk1cMAJng6QBJ3Qhck" \
  -n chaos-engine
