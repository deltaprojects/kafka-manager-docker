# kafka manager docker container
This docker container runs [CMAK](https://github.com/yahoo/CMAK)(formerly Kafka Manager), a UI for [Apache Kafka](http://kafka.apache.org).

The base image used is [azul/zulu-openjdk-alpine:11](https://hub.docker.com/r/azul/zulu-openjdk-alpine). Meaning it runs alpine and openjdk JDK v11.

### Environment variables
Here are the available environment variables.
I think the list is self-explanatory.

```bash
ZK_HOSTS=zk01.local:2181,zk02.local:2181
KAFKA_MANAGER_AUTH_ENABLED=false # default value
KAFKA_MANAGER_USERNAME=admin # default value
KAFKA_MANAGER_PASSWORD=password # default value
KAFKA_MANAGER_LDAP_ENABLED=false
KAFKA_MANAGER_LDAP_SERVER=""
KAFKA_MANAGER_LDAP_PORT=389
KAFKA_MANAGER_LDAP_USERNAME=""
KAFKA_MANAGER_LDAP_PASSWORD=""
KAFKA_MANAGER_LDAP_SEARCH_BASE_DN=""
KAFKA_MANAGER_LDAP_SEARCH_FILTER='(uid=$capturedLogin$)'
KAFKA_MANAGER_LDAP_CONNECTION_POOL_SIZE=10
KAFKA_MANAGER_LDAP_SSL=false
KAFKA_MANAGER_EXTRA_PLAY_OPTS=""


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

LDAP + SSL example:
```
docker run \
	--name=kafka-manager \
	--env="ZK_HOSTS=zk01.example.com:2181,zk02.example.com:2181,zk03.example.com:2181" \
	--env="KAFKA_MANAGER_AUTH_ENABLED=true" \
	--env="KAFKA_MANAGER_USERNAME=admin" \
	--env="KAFKA_MANAGER_PASSWORD=password" \
	--env="KAFKA_MANAGER_LDAP_ENABLED=true" \
	--env="KAFKA_MANAGER_LDAP_SERVER=ldap.example.com" \
	--env="KAFKA_MANAGER_LDAP_PORT=636" \
	--env="KAFKA_MANAGER_LDAP_USERNAME=cn=rouser,dc=example,dc=com" \
	--env="KAFKA_MANAGER_LDAP_PASSWORD=rouserpassword" \
	--env="KAFKA_MANAGER_LDAP_SEARCH_BASE_DN=ou=users,dc=example,dc=com" \
	--env="KAFKA_MANAGER_LDAP_SEARCH_FILTER=(&(objectClass=inetOrgPerson)(&(uid=\$capturedLogin\$)(|(memberof=cn=Operations,ou=Groups,dc=example,dc=com)(memberof=cn=Development,ou=Groups,dc=example,dc=com))))" \
	--env="KAFKA_MANAGER_LDAP_CONNECTION_POOL_SIZE=10" \
	--env="KAFKA_MANAGER_LDAP_SSL=true" \
	--env="KAFKA_MANAGER_EXTRA_PLAY_OPTS=-Dhttp.port=9000 -Dhttps.port=9443" \
	--network=bridge \
	-p 0.0.0.0:443:9443 \
	-p 0.0.0.0:80:9000 \
	--restart=always \
	--detach=true \
	deltaprojects/kafka-manager:latest
```


### Quirks
- Changing APPLICATION_SECRET requires you to remove /kafka-manager znode from zookeeeper and reconfigure kafka-manager.

### Deploy @ Delta Projects
Commit and push your changes to master.
Add a release tag like this (vX.X.X.X-Y, X=CMAK version, Y=deployment/docker iteration):

```
$ git tag
...
v3.0.0.4-2
v3.0.0.4-3
v3.0.0.4-4
v3.0.0.4-5
$ git tag v3.0.0.4-6
$ git push --tags
```

### Contribute
* Create issues.
* Create pull requests.
