# kafka manager docker container
This docker container runs [kafka manager](https://github.com/yahoo/kafka-manager), a UI for [Apache Kafka](http://kafka.apache.org).

The base image used is [openjdk:8-jre-alpine](https://hub.docker.com/_/openjdk/). Meaning it runs alpine and openjdk JRE v8.

### Environment variables
Here are the available environment variables.
I think the list is self-explanatory.

```bash
ZK_HOSTS=zk01.local:2181,zk02.local:2181
KAFKA_MANAGER_AUTH_ENABLED=false # default value
KAFKA_MANAGER_USERNAME=admin # default value
KAFKA_MANAGER_PASSWORD=password # default value
APPLICATION_SECRET="RANDOMCHARACTERS" # uses default value from from kafka manager if not set.
JAVA_OPTS="-Djava.net.preferIPv4Stack=true -Xmx2G ..." # default is no JAVA_OPTS
```


### Quick Start
```
docker run -d --name kafka-manager -p 9000:9000 -e ZK_HOSTS="zk01.local:2181" -e KAFKA_MANAGER_USERNAME=admin -e KAFKA_MANAGER_PASSWORD=password deltaprojects/kafka-manager
```

### Pass arguments to kafka-manager
Use the `JAVA_OPTS` environment variable to pass attributes/options to the jvm or kafka manager.

Example:

```
docker run -d --name kafka-manager -p 9000:9000 -e ZK_HOSTS="zk01.local:2181" -e APPLICATION_SECRET="€/DDFsdfa.," -e JAVA_OPTS="-Djava.net.preferIPv4Stack=true -Dlogger.file=/mnt/logger.xml -Xmx2G" deltaprojects/kafka-manager
```

### Quirks
- Changing APPLICATION_SECRET requires you to remove /kafka-manager znode from zookeeeper and reconfigure kafka-manager.

### Contribute
* Create issues.
* Create pull requests.
