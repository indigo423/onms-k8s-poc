#!/usr/bin/env bash

OPENNMS_HOME="/opt/opennms"
CONFIG_DIR="${OPENNMS_HOME}/etc"

umask 002

if [ ! "$(ls --ignore .git --ignore .gitignore -A ${OPENNMS_HOME}/etc)"  ]; then
  echo "No existing configuration in ${OPENNMS_HOME}/etc found. Initialize from etc-pristine."
  cp -r ${OPENNMS_HOME}/share/etc-pristine/* ${OPENNMS_HOME}/etc/ || exit ${E_INIT_CONFIG}
fi

cat <<EOF > "${CONFIG_DIR}/opennms.properties.d/instanceid.properties"
org.opennms.instance.id=OpenNMS
EOF

cat <<EOF > "${CONFIG_DIR}/org.opennms.features.datachoices.cfg"
enabled=false
acknowledged-by=admin
acknowledged-at=Mon Jan 01 00\:00\:00 EDT 2022
EOF

cat <<EOF > "${CONFIG_DIR}/opennms.properties.d/webui.properties"
opennms.web.base-url=http://%x%c/
org.opennms.security.disableLoginSuccessEvent=true
org.opennms.web.defaultGraphPeriod=last_2_hour
EOF

cat <<EOF > "${CONFIG_DIR}/opennms.properties.d/activemq.properties"
org.opennms.activemq.broker.disable=true
EOF

cat <<EOF > "${CONFIG_DIR}/opennms.properties.d/kafka.properties"
org.opennms.core.ipc.strategy=kafka

# TWIN
org.opennms.core.ipc.twin.kafka.bootstrap.servers=192.168.178.22:9092
org.opennms.core.ipc.twin.kafka.group.id=OpenNMS-Core-Twin

# SINK
org.opennms.core.ipc.sink.initialSleepTime=60000
org.opennms.core.ipc.sink.kafka.bootstrap.servers=192.168.178.22:9092
org.opennms.core.ipc.sink.kafka.group.id=OpenNMS-Core-Sink

# SINK Consumer (verify Kafka broker configuration)
org.opennms.core.ipc.sink.kafka.session.timeout.ms=30000
org.opennms.core.ipc.sink.kafka.max.poll.records=50

# RPC
org.opennms.core.ipc.rpc.kafka.bootstrap.servers=192.168.178.22:9092
org.opennms.core.ipc.rpc.kafka.ttl=30000
org.opennms.core.ipc.rpc.kafka.single-topic=true
org.opennms.core.ipc.rpc.kafka.group.id=OpenNMS-Core-RPC

# RPC Consumer (verify Kafka broker configuration)
org.opennms.core.ipc.rpc.kafka.request.timeout.ms=30000
org.opennms.core.ipc.rpc.kafka.session.timeout.ms=30000
org.opennms.core.ipc.rpc.kafka.max.poll.records=50
org.opennms.core.ipc.rpc.kafka.auto.offset.reset=latest

# RPC Producer (verify Kafka broker configuration)
org.opennms.core.ipc.rpc.kafka.acks=0
org.opennms.core.ipc.rpc.kafka.linger.ms=5
EOF

cat <<EOF > "${CONFIG_DIR}/opennms.properties.d/collectd.properties"
# To get data as close as possible to PDP
org.opennms.netmgt.collectd.strictInterval=true
EOF
