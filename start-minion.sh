#!/bin/bash
# @author Alejandro Galue <agalue@opennms.com>

minion_version="29.0.1" # Must match the version chosen for OpenNMS
minion_location="Apex"
minion_id="minion-1"
instance_id="onms"  # Must match OPENNMS_INSTANCE_ID from app-settings
kafka_boostrap="kafka.k8s.agalue.net:443" # Ensure it points to the same Kafka cluster used by OpenNMS
kafka_user="opennms" # Must match KAFKA_SASL_USERNAME from app-credentials
kafka_passwd="0p3nNM5" # Must match KAFKA_SASL_PASSWORD from app-credentials
jks_passwd="0p3nNM5" # Must match KAFKA_SSL_TRUSTSTORE_PASSWORD from app-credentials
jks_file="kafka-truststore.jks" # Must be consistent with KAFKA_SSL_TRUSTSTORE from app-settings

# Build Minion Configuration
cat <<EOF > minion.yaml
id: ${minion_id}
location: ${minion_location}
system:
  properties:
    org.opennms.instance.id: ${instance_id}
ipc:
EOF
for module in rpc sink twin; do
  cat <<EOF >> minion.yaml
  $module:
    kafka:
      bootstrap.servers: ${kafka_boostrap}
      security.protocol: SASL_SSL
      sasl.mechanism: SCRAM-SHA-512
      sasl.jaas.config: org.apache.kafka.common.security.scram.ScramLoginModule required username="${kafka_user}" password="${kafka_passwd}";
      ssl.truststore.location: /opt/minion/etc/${jks_file}
      ssl.truststore.password: ${jks_passwd}
EOF
done

# Start Minion via Docker
docker run --name minion -it --rm \
 -e TZ=America/New_York \
 -p 8201:8201 \
 -p 1514:1514/udp \
 -p 1162:1162/udp \
 -v $(pwd)/k8s/pki/${jks_file}:/opt/minion/etc/${jks_file} \
 -v $(pwd)/minion.yaml:/opt/minion/minion-config.yaml \
 opennms/minion:${minion_version} -c
rm minion.yaml