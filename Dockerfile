FROM maven:3.8.1-jdk-11 AS build

# Copy project files
WORKDIR /app
COPY pom.xml .
COPY src ./src
# COPY webapp ./webapp

# Build the WAR file
RUN mvn package -X

FROM tomcat:9.0-jdk11-slim

COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/

# Install the Snowflake JDBC driver
COPY snowflake-jdbc-3.21.0.jar /usr/local/tomcat/lib/

# Copy the startup script
COPY startup.sh /usr/local/tomcat/bin/
RUN chmod +x /usr/local/tomcat/bin/startup.sh

# Expose the Tomcat port
EXPOSE 8080

CMD ["/usr/local/tomcat/bin/startup.sh"]
