Tomcat Test Snowflake connection

```
docker compose build
```

```
docker compose up
```

Navigate to: `http://localhost:8080/tomcat_snowflake/test`

If successful:

```
Snowflake connection successful!
Result: 1
```

Generate Snowflake RSA Key:
```
openssl genrsa 2048 | openssl pkcs8 -topk8 -v2 des3 -inform PEM -out snowflake_rsa_key.p8
```
