#!/usr/bin/env bash

# Example with credentials to access postgres database
# Make sure the postgres password is set and the opennms user and database is created
# sudo -i -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'xQadUEDMc4ejp7p7';"
# sudo -i -u postgres createuser -P opennms # in this example password would be cglk1cMAJng6QBJ3Qhck
# sudo -i -u postgres createdb -O opennms opennms
#
kubectl create secret generic hzn-core-secrets \
  --from-literal="POSTGRES_PASSWORD=xQadUEDMc4ejp7p7" \
  --from-literal="OPENNMS_DBPASS=cglk1cMAJng6QBJ3Qhck" \
  -n opennms-poc
