# Tomcat Test Snowflake connection

This is a sample application to show how to connect to Snowflake from a Java web application running on Tomcat using Key-Pair authentication.

Snowflake will block single factor authentication for Services by November 2025: https://www.snowflake.com/en/blog/blocking-single-factor-password-authentification/

I've also written about these changes on https://www.ostberg.dev/projects/2025/01/25/snowflake-key-pair-authentication.html

## Prerequisites

- Docker

## Usage

Generate key pair for Snowflake connection and configure the user

https://docs.snowflake.com/en/user-guide/key-pair-auth

Generate Snowflake RSA Key:

```
openssl genrsa 2048 | openssl pkcs8 -topk8 -v2 des3 -inform PEM -out snowflake_rsa_key.p8
```

Setup the environment variables:

```
SNOWFLAKE_USER=<username>
SNOWFLAKE_RSA_KEY=<rsa_key>
SNOWFLAKE_RSA_KEY_PASSWORD=<rsa_key_password>
SNOWFLAKE_HOSTNAME=<hostname>
SNOWFLAKE_DATABASE=<database>
SNOWFLAKE_SCHEMA=<schema>
SNOWFLAKE_WAREHOUSE=<warehouse>
```

Build and run the Docker container:

```
docker compose build
docker compose up
```

Navigate to: `http://localhost:8080/tomcat_snowflake/test`

If successful:

```
Snowflake connection successful!
Result: 1
```
