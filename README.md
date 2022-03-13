# Build

```
bash generate-certificates.sh
mvn clean install
```

# Run

```
java -jar target/spring-boot-mutual-tls-1.0-SNAPSHOT.jar
```

# Demo

```
curl -v http://localhost:18080/hello
```

The request gets rejected because it requires TLS.

```
curl -v https://localhost:18080/hello
```

The request gets rejected due to the missing CA.

```
curl -v -k https://localhost:18080/hello
```

or

```
curl -v \
    --cacert certificates/ca.crt \
    https://localhost:18080/hello
```

The request gets rejected due to a missing client certificate.

```
curl -v \
    --cacert certificates/ca.crt \
    --cert certificates/client.crt \
    --key certificates/client.key \
    https://localhost:18080/hello
```

The request returns with the expected result `Authenticated and authorized!` - the log
shows `Authorising user client`.

```
curl -v \
    --cacert certificates/ca.crt \
    --cert certificates/unregistered-client.crt \
    --key certificates/unregistered-client.key \
    https://localhost:18080/hello
```

The request gets rejected because the client is unknown to the server - the log
shows `Authorising user client-2`.

```
curl -v \
    --cacert certificates/ca.crt \
    --cert certificates/malicious-client.crt \
    --key certificates/malicious-client.key \
    https://localhost:18080/hello
```

The request gets rejected due to a faulty client certificate (wrong CA) - therefore, no log entry
because the request never reaches Spring.