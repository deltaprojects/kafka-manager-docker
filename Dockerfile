### STAGE 1: Build ###
FROM azul/zulu-openjdk-alpine:11 AS build

ENV KAFKA_MANAGER_VERSION=3.0.0.6

RUN echo "Building Kafka Manager/CMAK" \
  && apk add --no-cache git bash \
  && mkdir -p /tmp \
  && cd /tmp \
  && git clone -b ${KAFKA_MANAGER_VERSION} https://github.com/yahoo/CMAK \
  && cd /tmp/CMAK \
  && ./sbt clean dist \
  || ./sbt clean dist \
  || ./sbt clean dist \
  && unzip -d /tmp target/universal/cmak-${KAFKA_MANAGER_VERSION}.zip

### STAGE 2: Package ###
FROM azul/zulu-openjdk-alpine:11
LABEL maintainer="Delta Projects"

ENV KAFKA_MANAGER_VERSION=3.0.0.6
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

COPY --from=build /tmp/cmak-${KAFKA_MANAGER_VERSION} /opt/cmak
COPY logback.xml /opt/cmak/conf

RUN apk add --no-cache git bash
RUN find /opt/cmak

EXPOSE 9000
EXPOSE 9443

WORKDIR /opt/cmak
#ENV application.home=/opt/cmak

ENTRYPOINT ["/bin/bash","-c"]
CMD ["/opt/cmak/bin/cmak -Dconfig.file=/opt/cmak/conf/application.conf ${KAFKA_MANAGER_EXTRA_PLAY_OPTS}"]
