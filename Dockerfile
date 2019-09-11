### STAGE 1: Build ###
FROM openjdk:8-jdk-alpine AS build

ENV KAFKA_MANAGER_VERSION=2.0.0.2

RUN echo "Building Kafka Manager" \
  && apk add --no-cache git bash \
  && mkdir -p /tmp \
  && cd /tmp \
  && git clone -b ${KAFKA_MANAGER_VERSION} https://github.com/yahoo/kafka-manager \
  && cd /tmp/kafka-manager \
  && ./sbt clean dist \
  || ./sbt clean dist \
  || ./sbt clean dist \
  && unzip -d /tmp target/universal/kafka-manager-${KAFKA_MANAGER_VERSION}.zip

### STAGE 2: Package ###
FROM openjdk:8-jre-alpine
MAINTAINER Delta Projects

ENV KAFKA_MANAGER_VERSION=2.0.0.2
ENV ZK_HOSTS=localhost:2181
ENV KAFKA_MANAGER_AUTH_ENABLED=true
ENV KAFKA_MANAGER_USERNAME=admin
ENV KAFKA_MANAGER_PASSWORD=password
ENV APPLICATION_SECRET="^<csmm5Fx4d=r2HEX8pelM3iBkFVv?k[mc;IZE<_Qoq8EkX_/7@Zt6dP05Pzea3U"

ENV KAFKA_MANAGER_LDAP_ENABLED=false
ENV KAFKA_MANAGER_LDAP_SERVER=""
ENV KAFKA_MANAGER_LDAP_PORT=389
ENV KAFKA_MANAGER_LDAP_USERNAME=""
ENV KAFKA_MANAGER_LDAP_PASSWORD=""
ENV KAFKA_MANAGER_LDAP_SEARCH_BASE_DN=""
ENV KAFKA_MANAGER_LDAP_SEARCH_FILTER="(uid=$capturedLogin$)"
ENV KAFKA_MANAGER_LDAP_CONNECTION_POOL_SIZE=10
ENV KAFKA_MANAGER_LDAP_SSL=false
ENV KAFKA_MANAGER_EXTRA_PLAY_OPTS=""

ENV JAVA_OPTS=""

COPY --from=build /tmp/kafka-manager-${KAFKA_MANAGER_VERSION} /opt/kafka-manager
COPY logback.xml /opt/kafka-manager/conf

RUN apk add --no-cache git bash

EXPOSE 9000
EXPOSE 9443

WORKDIR /opt/kafka-manager
#ENV application.home=/opt/kafka-manager

ENTRYPOINT ["/bin/bash","-c"]
CMD ["/opt/kafka-manager/bin/kafka-manager -Dconfig.file=/opt/kafka-manager/conf/application.conf ${KAFKA_MANAGER_EXTRA_PLAY_OPTS}"]
