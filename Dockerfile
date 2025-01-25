# Stage 1: Build the WAR file
FROM maven:3.8.4-openjdk-11 AS build

WORKDIR /app
COPY pom.xml .
COPY src ./src

# Build the WAR file
RUN mvn package

# Stage 2: Create the final image
FROM tomcat:9.0.53-jdk11

# Set environment variables
ENV SNOWFLAKE_USER=demo \
    SNOWFLAKE_RSA_KEY=key \
    SNOWFLAKE_RSA_KEY_PASSWORD=password \
    SNOWFLAKE_HOSTNAME=test.snowflakecomputing.com \
    SNOWFLAKE_DATABASE=demo_db \
    SNOWFLAKE_SCHEMA=demo_schema \
    SNOWFLAKE_WAREHOUSE=demo_wh

# Install dependencies and clean up
RUN apt-get update && \
    apt-get install -y wget gettext && \
    rm -rf /var/lib/apt/lists/*

# Copy the Test Servlet WAR file from the build stage
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/

# Download the Snowflake JDBC driver
RUN wget -O /usr/local/tomcat/lib/snowflake-jdbc-3.21.0.jar https://repo1.maven.org/maven2/net/snowflake/snowflake-jdbc/3.21.0/snowflake-jdbc-3.21.0.jar

# Copy the Tomcat configuration
COPY tomcat /usr/local/tomcat

# Copy the startup script and make it executable
COPY startup.sh /usr/local/tomcat/bin/
RUN chmod +x /usr/local/tomcat/bin/startup.sh

# Expose the Tomcat port
EXPOSE 8080

# Set the startup command
CMD ["/usr/local/tomcat/bin/startup.sh"]